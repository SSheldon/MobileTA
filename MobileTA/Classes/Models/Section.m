//
//  Section.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Section.h"
#import "AttendanceRecord.h"
#import "Room.h"
#import "Student.h"


@implementation Section

@dynamic name;
@dynamic course;
@dynamic attendanceRecords;
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
  return [context executeFetchRequest:fetch error:nil];
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

@end
