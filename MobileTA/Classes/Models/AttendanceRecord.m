//
//  AttendanceRecord.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "AttendanceRecord.h"
#import "Section.h"
#import "StudentAttendance.h"


@implementation AttendanceRecord

@dynamic date;
@dynamic name;
@dynamic section;
@dynamic studentAttendances;

+ (AttendanceRecord *)attendanceRecordForName:(NSString *)name date:(NSDate *)date context:(NSManagedObjectContext *)context {
  AttendanceRecord *attendanceRecord = [NSEntityDescription insertNewObjectForEntityForName:@"AttendanceRecord" inManagedObjectContext:context];
  
  attendanceRecord.name = name;
  attendanceRecord.date = date;
  
  return attendanceRecord;
}

+ (AttendanceRecord *)attendanceRecordForSection:(Section *)section context:(NSManagedObjectContext *)context {
  AttendanceRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"AttendanceRecord" inManagedObjectContext:context];

  record.section = section;

  return record;
}

@end
