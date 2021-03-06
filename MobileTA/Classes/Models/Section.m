//
//  Section.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Section.h"
#import "AttendanceRecord.h"
#import "Group.h"
#import "Room.h"
#import "Student.h"
#import "StudentAttendance.h"
#import "CHCSVParser.h"

@implementation Section

@dynamic name;
@dynamic course;
@dynamic attendanceRecords;
@dynamic groups;
@dynamic room;
@dynamic students;

+ (Section *)sectionWithName:(NSString *)name course:(NSString *)course context:(NSManagedObjectContext *)context {
  Section *section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:context];
  
  section.name = name;
  section.course = course;
  return section;
}

+ (NSArray *)fetchSectionsInContext:(NSManagedObjectContext *)context {
  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
  fetch.entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:context];
  // TODO(ssheldon): Handle errors
  NSArray *sections = [context executeFetchRequest:fetch error:nil];

#if DEBUG
  // If there are no sections, create a sample one
  if (!sections.count) {
    sections = @[
      [Section sectionWithName:@"AD1" course:@"CS 428" context:context],
    ];
    [context save:nil];
  }
#endif

  return sections;
}

- (AttendanceRecord *)attendanceRecordNearestToDate:(NSDate *)date withinTimeInterval:(NSTimeInterval)seconds {
  AttendanceRecord *nearest = nil;
  NSTimeInterval minDiff;

  for (AttendanceRecord *record in self.attendanceRecords) {
    if (record.date) {
      NSTimeInterval diff = [date timeIntervalSinceDate:record.date];
      if (!nearest || ABS(diff) < ABS(minDiff)) {
        nearest = record;
        minDiff = diff;
      }
    }
  }

  // If an interval was supplied but the nearest is within it, return nil
  if (seconds && nearest && ABS(minDiff) > ABS(seconds)) {
    return nil;
  }

  return nearest;
}

- (NSString *)displayName {
  NSString *display = self.course;
  
  if (self.name.length) {
    if (display.length) {
      display = [display stringByAppendingFormat:@" - %@", self.name];
    } else {
      display = self.name;
    }
  }
  
  return display;
}

- (NSArray *)sortedGroups {
  NSArray *sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
  ];
  return [[self.groups allObjects] sortedArrayUsingDescriptors:sortDescriptors];
}

- (Student *)randomStudent {
  // Create a mapping from Student object ID to total participation
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  for (Student *student in self.students) {
    NSInteger totalParticipation = [student totalParticipation];
    [dict setObject:[NSNumber numberWithInteger:totalParticipation] forKey:student.objectID];
  }

  // Sorted ASCENDING
  NSMutableArray *students = [NSMutableArray arrayWithArray:[self.students allObjects]];
  [students sortUsingComparator:^NSComparisonResult(Student *student1, Student *student2) {
    return [[dict objectForKey:student1.objectID] compare:[dict objectForKey:student2.objectID]];
  }];
  int bottomThird = students.count / 3;
  NSUInteger randomIndex = arc4random() % bottomThird;
  return [students objectAtIndex:randomIndex];
}

- (void)writeCSVToOutputStream:(NSOutputStream *)stream withAttendanceRecord:(AttendanceRecord *)record {
  CHCSVWriter *writer = [[CHCSVWriter alloc] initWithOutputStream:stream encoding:NSUTF8StringEncoding delimiter:','];

  // Write header
  NSMutableArray *header = [NSMutableArray arrayWithArray:@[@"Last Name", @"First Name", @"Nickname", @"Email"]];
  if (record) {
    [header addObjectsFromArray:@[@"Attendance", @"Particpation"]];
  }
  [header addObject:@"Notes"];
  [writer writeLineOfFields:header];

  // Sort the students
  NSArray *sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
  ];
  NSArray *students = [[self.students allObjects] sortedArrayUsingDescriptors:sortDescriptors];

  // Write each student as a row
  for (Student *student in students) {
    [writer writeField:student.lastName];
    [writer writeField:student.firstName];
    [writer writeField:student.nickname];
    [writer writeField:student.email];
    if (record) {
      StudentAttendance *attendance = [record studentAttendanceForStudent:student];
      [writer writeField:NSStringFromStudentAttendanceStatus(attendance.status)];
      [writer writeField:[NSString stringWithFormat:@"%d", attendance.participation]];
    }
    [writer writeField:student.notes];
    [writer finishLine];
  }

  [writer closeStream];
}

- (NSString *)CSVStringWithAttendanceRecord:(AttendanceRecord *)record {
  NSOutputStream *stream = [NSOutputStream outputStreamToMemory];
  [self writeCSVToOutputStream:stream withAttendanceRecord:record];
  NSData *buffer = [stream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
  return [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];

}

- (NSComparisonResult)compare:(Section *)otherObject {
  if ([self.course compare:otherObject.course] == NSOrderedSame) {
    return [self.name compare:otherObject.name];
  }
  return [self.course compare:otherObject.course];
}

@end
