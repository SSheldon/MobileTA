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

+ (StudentAttendance *)studentAttendanceWithStatus:(StudentAttendanceStatus)status participation:(NSInteger)participation context:(NSManagedObjectContext *)context {
  StudentAttendance *attendance = [NSEntityDescription insertNewObjectForEntityForName:@"StudentAttendance" inManagedObjectContext:context];

  attendance.statusValue = status;
  attendance.participationValue = participation;

  return attendance;
}

+ (StudentAttendance *)studentAttendanceWithContext:(NSManagedObjectContext *)context {
  return [self studentAttendanceWithStatus:StudentAttendanceStatusPresent participation:0 context:context];
}

- (StudentAttendanceStatus)statusValue {
  return (StudentAttendanceStatus)self.status.integerValue;
}

- (void)setStatusValue:(StudentAttendanceStatus)statusValue {
  self.status = [NSNumber numberWithInteger:statusValue];
}

- (NSInteger)participationValue {
  return self.participation.integerValue;
}

- (void)setParticipationValue:(NSInteger)participationValue {
  self.participation = [NSNumber numberWithInteger:participationValue];
}

@end
