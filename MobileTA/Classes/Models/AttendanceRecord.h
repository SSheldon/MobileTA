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

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) Section *section;
@property (nonatomic, retain) NSSet *studentAttendances;
@end

@interface AttendanceRecord (CoreDataGeneratedAccessors)

- (void)addStudentAttendancesObject:(StudentAttendance *)value;
- (void)removeStudentAttendancesObject:(StudentAttendance *)value;
- (void)addStudentAttendances:(NSSet *)values;
- (void)removeStudentAttendances:(NSSet *)values;

@end
