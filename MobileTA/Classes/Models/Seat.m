//
//  Seat.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Seat.h"
#import "Room.h"
#import "Student.h"


@implementation Seat

@dynamic x;
@dynamic y;
@dynamic room;
@dynamic students;

- (CGPoint)location {
  return CGPointMake(self.x, self.y);
}

- (void)setLocation:(CGPoint)location {
  self.x = location.x;
  self.y = location.y;
}

@end
