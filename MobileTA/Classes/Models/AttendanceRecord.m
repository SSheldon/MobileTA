//
//  AttendanceRecord.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "AttendanceRecord.h"

#import "Section.h"
#import "Student.h"
#import "StudentAttendance.h"


@implementation AttendanceRecord

@dynamic date;
@dynamic name;
@dynamic section;
@dynamic studentAttendances;

+ (AttendanceRecord *)attendanceRecordWithContext:(NSManagedObjectContext *)context {
  return [AttendanceRecord attendanceRecordWithDate:[NSDate date] context:context];
}

+ (AttendanceRecord *)attendanceRecordWithDate:(NSDate *)date context:(NSManagedObjectContext *)context {
  AttendanceRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"AttendanceRecord" inManagedObjectContext:context];
  record.date = date;
  return record;
}

+ (AttendanceRecord *)attendanceRecordForName:(NSString *)name date:(NSDate *)date context:(NSManagedObjectContext *)context {
  AttendanceRecord *attendanceRecord = [AttendanceRecord attendanceRecordWithDate:date context:context];
  attendanceRecord.name = name;
  return attendanceRecord;
}

+ (AttendanceRecord *)attendanceRecordForSection:(Section *)section context:(NSManagedObjectContext *)context {
  AttendanceRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"AttendanceRecord" inManagedObjectContext:context];

  record.section = section;

  return record;
}

- (StudentAttendance *)studentAttendanceForStudent:(Student *)student {
  for (StudentAttendance *attendance in self.studentAttendances) {
    if ([student isEqual:attendance.student]) {
      return attendance;
    }
  }

  return nil;
}

- (NSString *) description {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"h:mm a EEE, MMM d, y"];
  NSString *description = [dateFormatter stringFromDate:self.date];
  if (self.name.length) {
    description = [description stringByAppendingFormat:@" %@", self.name];
  }
  return description;
}

- (NSString *) getDescriptionShort {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"MM-dd"];
  NSString *description = [dateFormatter stringFromDate:self.date];
  if (self.name.length) {
    description = [description stringByAppendingFormat:@" %@", self.name];
  }
  return description;
}

@end
