//
//  StudentAttendance.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AttendanceRecord, Student;

typedef NS_ENUM(int16_t, StudentAttendanceStatus) {
  StudentAttendanceStatusPresent,
  StudentAttendanceStatusAbsent,
  StudentAttendanceStatusTardy
};

/*/
 *  Returns a string suitable for displaying to the user from a given participation
 *
 *  Examples (Input => Output):
 *  -10 => @"-10"
 *  0   => @""
 *  10  => @"+10"
/*/
NSString *NSStringFromStudentParticipation(int16_t participation);

NSString *NSStringFromStudentAttendanceStatus(StudentAttendanceStatus status);

@interface StudentAttendance : NSManagedObject

@property (nonatomic) int16_t participation;
@property (nonatomic) StudentAttendanceStatus status;
@property (nonatomic, retain) AttendanceRecord *attendanceRecord;
@property (nonatomic, retain) Student *student;

+ (StudentAttendance *)studentAttendanceWithStatus:(StudentAttendanceStatus)status participation:(int16_t)participation context:(NSManagedObjectContext *)context;
+ (StudentAttendance *)studentAttendanceWithContext:(NSManagedObjectContext *)context;

@end
