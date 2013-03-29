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

@interface StudentAttendance : NSManagedObject

@property (nonatomic) int16_t participation;
@property (nonatomic) StudentAttendanceStatus status;
@property (nonatomic, retain) AttendanceRecord *attendanceRecord;
@property (nonatomic, retain) Student *student;

+ (StudentAttendance *)studentAttendanceWithStatus:(StudentAttendanceStatus)status participation:(int16_t)participation context:(NSManagedObjectContext *)context;
+ (StudentAttendance *)studentAttendanceWithContext:(NSManagedObjectContext *)context;

@end
