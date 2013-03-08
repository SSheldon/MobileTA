//
//  StudentAttendance.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "StudentAttendance.h"
#import "AttendanceRecord.h"
#import "Student.h"


@implementation StudentAttendance

@dynamic participation;
@dynamic status;
@dynamic attendanceRecord;
@dynamic student;

+ (StudentAttendance *)studentAttendanceWithStatus:(NSNumber *)status participation:(NSNumber *)participation context:(NSManagedObjectContext *)context {
  StudentAttendance *attendance = [NSEntityDescription insertNewObjectForEntityForName:@"StudentAttendance" inManagedObjectContext:context];
  
  attendance.status = status;
  attendance.participation = participation;
  return attendance;
}

+ (StudentAttendance *)studentAttendanceWithContext:(NSManagedObjectContext *)context {
  return [self studentAttendanceWithStatus:0 participation:0 context:context];
}

@end
