//
//  Room.h
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Room : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *seats;
@end

@interface Room (CoreDataGeneratedAccessors)

- (void)addSeatsObject:(NSManagedObject *)value;
- (void)removeSeatsObject:(NSManagedObject *)value;
- (void)addSeats:(NSSet *)values;
- (void)removeSeats:(NSSet *)values;

@end
