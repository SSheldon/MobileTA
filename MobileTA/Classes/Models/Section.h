//
//  Section.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AttendanceRecord, Group, Room, Student;

@interface Section : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString *course;
@property (nonatomic, retain) NSSet *attendanceRecords;
@property (nonatomic, retain) NSSet *groups;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) NSSet *students;

/*!
 * Creates a Section.
 *
 * @param name the Section's name
 * @param course the name of the Section's course
 * @param context the NSManagedObjectContext to insert the Section into
 */
+ (Section *)sectionWithName:(NSString *)name course:(NSString *)course context:(NSManagedObjectContext *)context;

+ (NSArray *)fetchSectionsInContext:(NSManagedObjectContext *)context;

/*!
 * Gets the AttendanceRecord of this Section that is
 * nearest to a given date but within a given time interval.
 *
 * @param date the NSDate to find the record nearest to
 * @param seconds if nonzero, the time interval, in seconds,
 *                that the record should be within
 * @return the AttendanceRecord of this Section
 */
- (AttendanceRecord *)attendanceRecordNearestToDate:(NSDate *)date withinTimeInterval:(NSTimeInterval)seconds;

/*!
 * Gets a name for this Section meant to be displayed.
 */
- (NSString *)displayName;

- (NSArray *)sortedGroups;

/*!
 * Writes this Section and the given AttendanceRecord as
 * comma separated values to an output stream.
 *
 * @param stream the NSOutputStream that CSV should be written to
 * @param record an AttendanceRecord of this Section
 */
- (void)writeCSVToOutputStream:(NSOutputStream *)stream withAttendanceRecord:(AttendanceRecord *)record;

/*!
 * Gets an NSString CSV representation of
 * this Section and AttendanceRecord.
 *
 * @param record an AttendanceRecord of this Section
 */
- (NSString *)CSVStringWithAttendanceRecord:(AttendanceRecord *)record;

- (NSComparisonResult)compare:(Section *)otherObject;

@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addAttendanceRecordsObject:(AttendanceRecord *)value;
- (void)removeAttendanceRecordsObject:(AttendanceRecord *)value;
- (void)addAttendanceRecords:(NSSet *)values;
- (void)removeAttendanceRecords:(NSSet *)values;

- (void)addGroupsObject:(Group *)value;
- (void)removeGroupsObject:(Group *)value;
- (void)addGroups:(NSSet *)values;
- (void)removeGroups:(NSSet *)values;

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
