//
//  Room.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Room.h"
#import "Seat.h"
#import "Section.h"


@implementation Room

@dynamic name;
@dynamic seats;
@dynamic sections;

+ (Room *)roomWithContext:(NSManagedObjectContext *)context {
  return [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:context];
}

- (BOOL)canMoveSeat:(Seat *)seat toX:(int16_t)x y:(int16_t)y {
  for (Seat *other in self.seats) {
    if ([other intersectsWithSeatAtX:x y:y] && ![other isEqual:seat]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)canMoveSeat:(Seat *)seat toLocation:(CGPoint)location {
  return [self canMoveSeat:seat toX:location.x y:location.y];
}

- (BOOL)canAddSeatAtX:(int16_t)x y:(int16_t)y {
  return [self canMoveSeat:nil toX:x y:y];
}

- (BOOL)canAddSeatAtLocation:(CGPoint)location {
  return [self canAddSeatAtX:location.x y:location.y];
}

- (BOOL)canAddSeat:(Seat *)seat {
  return [self canAddSeatAtX:seat.x y:seat.y];
}

@end
