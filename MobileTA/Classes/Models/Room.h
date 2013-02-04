//
//  Room.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Seat, Section;

@interface Room : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *seats;
@property (nonatomic, retain) NSSet *sections;
@end

@interface Room (CoreDataGeneratedAccessors)

- (void)addSeatsObject:(Seat *)value;
- (void)removeSeatsObject:(Seat *)value;
- (void)addSeats:(NSSet *)values;
- (void)removeSeats:(NSSet *)values;

- (void)addSectionsObject:(Section *)value;
- (void)removeSectionsObject:(Section *)value;
- (void)addSections:(NSSet *)values;
- (void)removeSections:(NSSet *)values;

@end
