//
//  Seat.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Room, Section, Student;

@interface Seat : NSManagedObject

@property (nonatomic) int16_t x;
@property (nonatomic) int16_t y;
@property (nonatomic, retain) Room *room;
@property (nonatomic, retain) NSSet *students;

+ (Seat *)seatWithContext:(NSManagedObjectContext *)context;
+ (Seat *)seatWithX:(int16_t)x y:(int16_t)y context:(NSManagedObjectContext *)context;

- (Student *)studentForSection:(Section *)section;
- (void)setStudent:(Student *)student forSection:(Section *)section;
- (CGPoint)location;
- (void)setLocation:(CGPoint)location;

@end

@interface Seat (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
