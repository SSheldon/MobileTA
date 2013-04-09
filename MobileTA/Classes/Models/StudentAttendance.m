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

NSString *NSStringFromStudentParticipation(int16_t participation) {
  // Special case, we don't want to display anything for 0 participation
  if (participation == 0) {
    return @"";
  }
  return [NSString stringWithFormat:(participation > 0 ? @"+%i" : @"%i"), participation];
}

NSString *NSStringFromStudentAttendanceStatus(StudentAttendanceStatus status) {
  switch (status) {
    case StudentAttendanceStatusPresent:
      return @"Present";
    case StudentAttendanceStatusAbsent:
      return @"Absent";
    case StudentAttendanceStatusTardy:
      return @"Tardy";
  }
  return nil;
}

@implementation StudentAttendance

@dynamic participation;
@dynamic status;
@dynamic attendanceRecord;
@dynamic student;

+ (StudentAttendance *)studentAttendanceWithStatus:(StudentAttendanceStatus)status participation:(int16_t)participation context:(NSManagedObjectContext *)context {
  StudentAttendance *attendance = [NSEntityDescription insertNewObjectForEntityForName:@"StudentAttendance" inManagedObjectContext:context];

  attendance.status = status;
  attendance.participation = participation;

  return attendance;
}

+ (StudentAttendance *)studentAttendanceWithContext:(NSManagedObjectContext *)context {
  return [self studentAttendanceWithStatus:StudentAttendanceStatusPresent participation:0 context:context];
}

@end
