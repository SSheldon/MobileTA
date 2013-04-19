//
//  AttendanceRecord.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section, Student, StudentAttendance;

@interface AttendanceRecord : NSManagedObject

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) Section *section;
@property (nonatomic, retain) NSSet *studentAttendances;

+ (AttendanceRecord *)attendanceRecordWithContext:(NSManagedObjectContext *)context;
+ (AttendanceRecord *)attendanceRecordWithDate:(NSDate *)date context:(NSManagedObjectContext *)context;
+ (AttendanceRecord *)attendanceRecordForName:(NSString *)name date:(NSDate *)date context:(NSManagedObjectContext *)context;

- (StudentAttendance *)studentAttendanceForStudent:(Student *)student;
- (NSString *)getDescriptionShort;

@end

@interface AttendanceRecord (CoreDataGeneratedAccessors)

- (void)addStudentAttendancesObject:(StudentAttendance *)value;
- (void)removeStudentAttendancesObject:(StudentAttendance *)value;
- (void)addStudentAttendances:(NSSet *)values;
- (void)removeStudentAttendances:(NSSet *)values;

@end
