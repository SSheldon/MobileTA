//
//  Student.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Seat, Section, StudentAttendance;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, retain) Section *section;
@property (nonatomic, retain) NSSet *attendances;
@property (nonatomic, retain) Seat *seat;

/*!
 * Create a Student.
 * @param firstName the Student's first name
 * @param lastName the Student's last name
 * @param context the NSManagedObjectContext to insert the Student into
 * @return the created Student
 */
+ (Student *)studentWithFirstName:(NSString *)firstName lastName:(NSString *)lastName context:(NSManagedObjectContext *)context;

/*!
 * Fetches all Students in a context.
 * @param context the NSManagedContext to fetch Students from
 * @return an NSArray of the fetched Students
 */
+ (NSArray *)fetchStudentsInContext:(NSManagedObjectContext *)context;

+ (NSArray *)studentsFromCSV:(NSArray *)csvContent context:(NSManagedObjectContext *)context;
+ (NSMutableArray *)parseMyCSVFile;

@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addAttendancesObject:(StudentAttendance *)value;
- (void)removeAttendancesObject:(StudentAttendance *)value;
- (void)addAttendances:(NSSet *)values;
- (void)removeAttendances:(NSSet *)values;

@end
