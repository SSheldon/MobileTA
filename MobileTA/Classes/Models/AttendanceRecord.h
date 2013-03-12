//
//  AttendanceRecord.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section, StudentAttendance;

@interface AttendanceRecord : NSManagedObject

+ (NSArray *)fetchAttendanceRecordsInContext:(NSManagedObjectContext *)context;


@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) Section *section;
@property (nonatomic, retain) NSSet *studentAttendances;

/*!
 * Create an AttendanceRecord.
 * @param section the Section of this AttendanceRecord
 * @param context the NSManagedObjectContext to insert the AttendanceRecord into
 * @return the created AttendanceRecord
 */
+ (AttendanceRecord *)attendanceRecordForSection:(Section *)section context:(NSManagedObjectContext *)context;

+ (AttendanceRecord *)attendanceRecordForName:(NSString *)name date:(NSDate *)date context:(NSManagedObjectContext *)context;

@end

@interface AttendanceRecord (CoreDataGeneratedAccessors)

- (void)addStudentAttendancesObject:(StudentAttendance *)value;
- (void)removeStudentAttendancesObject:(StudentAttendance *)value;
- (void)addStudentAttendances:(NSSet *)values;
- (void)removeStudentAttendances:(NSSet *)values;

@end
