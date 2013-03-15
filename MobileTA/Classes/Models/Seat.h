//
//  Seat.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Room, Student;

@interface Seat : NSManagedObject

@property (nonatomic, retain) NSNumber *x;
@property (nonatomic, retain) NSNumber *y;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) NSSet *students;
@end

@interface Seat (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
