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

typedef NS_ENUM(NSInteger, StudentAttendanceStatus) {
  StudentAttendanceStatusAbsent,
  StudentAttendanceStatusTardy,
  StudentAttendanceStatusPresent
};

@interface StudentAttendance : NSManagedObject

@property (nonatomic, retain) NSNumber * participation;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) AttendanceRecord *attendanceRecord;
@property (nonatomic, retain) Student *student;

@end
