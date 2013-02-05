//
//  Student.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentAttendance;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * first;
@property (nonatomic, retain) NSString * last;
@property (nonatomic, retain) StudentAttendance *studentAttendance;

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
