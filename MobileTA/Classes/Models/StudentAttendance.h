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

@property (nonatomic, retain) NSNumber * participation;     // 0 to 2, from low participation to high participation
@property (nonatomic, retain) NSNumber * status;            // 0 for absent; 1 for tardy; 2 for present
@property (nonatomic, retain) AttendanceRecord *attendanceRecord;
@property (nonatomic, retain) Student *student;

+ (StudentAttendance *)studentAttendanceWithStatus:(StudentAttendanceStatus)status participation:(NSInteger)participation context:(NSManagedObjectContext *)context;
+ (StudentAttendance *)studentAttendanceWithContext:(NSManagedObjectContext *)context;

@end
