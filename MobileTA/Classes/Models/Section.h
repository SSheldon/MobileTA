//
//  Section.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AttendanceRecord, Room, Student;

@interface Section : NSManagedObject

+ (Section *)sectionWithName:(NSString *)name context:(NSManagedObjectContext *)context;
+ (NSArray *)fetchSectionsInContext:(NSManagedObjectContext *)context;

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString *course;
@property (nonatomic, retain) NSSet *attendanceRecords;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) NSSet *students;
@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addAttendanceRecordsObject:(AttendanceRecord *)value;
- (void)removeAttendanceRecordsObject:(AttendanceRecord *)value;
- (void)addAttendanceRecords:(NSSet *)values;
- (void)removeAttendanceRecords:(NSSet *)values;

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
