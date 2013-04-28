//
//  Seat.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Seat.h"
#import "Room.h"
#import "Section.h"
#import "Student.h"
#import "TAGridConstants.h"

@implementation Seat

@dynamic x;
@dynamic y;
@dynamic room;
@dynamic students;

+ (Seat *)seatWithContext:(NSManagedObjectContext *)context {
  return [NSEntityDescription insertNewObjectForEntityForName:@"Seat" inManagedObjectContext:context];
}

+ (Seat *)seatWithX:(int16_t)x y:(int16_t)y context:(NSManagedObjectContext *)context {
  Seat *seat = [Seat seatWithContext:context];
  seat.x = x;
  seat.y = y;
  return seat;
}

- (NSUInteger)countOfStudentsInSection:(Section *)section {
  NSUInteger count = 0;
  for (Student *student in self.students) {
    if ([section isEqual:student.section]) {
      count++;
    }
  }
  return count;
}

- (Student *)studentForSection:(Section *)section {
  NSAssert([self countOfStudentsInSection:section] <= 1, @"Seats should only have one student for a section");

  for (Student *student in self.students) {
    if ([section isEqual:student.section]) {
      return student;
    }
  }

  return nil;
}

- (void)setStudent:(Student *)student forSection:(Section *)section {
  Student *oldStudent = [self studentForSection:section];
  if (oldStudent) {
    [self removeStudentsObject:oldStudent];
  }

  [self addStudentsObject:student];
}

- (CGPoint)location {
  return CGPointMake(self.x, self.y);
}

- (void)setLocation:(CGPoint)location {
  self.x = location.x;
  self.y = location.y;
}

- (BOOL)intersectsWithSeatAtX:(int16_t)x y:(int16_t)y {
  return ABS(self.x - x) < SEAT_WIDTH_UNITS && ABS(self.y - y) < SEAT_HEIGHT_UNITS;
}

- (BOOL)intersectsWithSeatAtLocation:(CGPoint)location {
  return [self intersectsWithSeatAtX:(int16_t)location.x y:(int16_t)location.y];
}

- (BOOL)intersectsWithSeat:(Seat *)other {
  return !!other && [self intersectsWithSeatAtX:other.x y:other.y];
}

@end
