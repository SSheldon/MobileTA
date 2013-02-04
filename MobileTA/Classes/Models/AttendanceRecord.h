//
//  AttendanceRecord.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AttendanceRecord : NSManagedObject

@property (nonatomic, retain) NSManagedObject *section;
@property (nonatomic, retain) NSSet *studentAttendances;
@end

@interface AttendanceRecord (CoreDataGeneratedAccessors)

- (void)addStudentAttendancesObject:(NSManagedObject *)value;
- (void)removeStudentAttendancesObject:(NSManagedObject *)value;
- (void)addStudentAttendances:(NSSet *)values;
- (void)removeStudentAttendances:(NSSet *)values;

@end
