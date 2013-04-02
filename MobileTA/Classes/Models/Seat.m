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

- (Student *)studentForSection:(Section *)section {
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

@end
