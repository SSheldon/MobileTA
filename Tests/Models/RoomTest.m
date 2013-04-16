//
//  RoomTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/15/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "Room.h"
#import "Seat.h"

@interface RoomTest : GHTestCase
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation RoomTest

- (void)setUp {
  self.managedObjectContext = [TATestUtils managedObjectContextForModelsInBundle:[NSBundle mainBundle]];
  if (!self.managedObjectContext) {
    GHFail(@"Could not create in-memory store.");
  }
}

- (void)tearDown {
  self.managedObjectContext = nil;
}

- (void)testCanMoveSeat {
  Room *room = [Room roomWithContext:self.managedObjectContext];

  Seat *seat1 = [Seat seatWithX:0 y:0 context:self.managedObjectContext];
  seat1.room = room;

  GHAssertFalse([room canAddSeatAtLocation:CGPointMake(2, 2)], nil);
  GHAssertTrue([room canMoveSeat:seat1 toLocation:CGPointMake(2, 2)], nil);

  Seat *seat2 = [Seat seatWithX:4 y:4 context:self.managedObjectContext];

  GHAssertTrue([room canAddSeat:seat2], nil);
  seat2.room = room;

  GHAssertFalse([room canMoveSeat:seat2 toLocation:CGPointMake(2, 2)], nil);
}

@end
