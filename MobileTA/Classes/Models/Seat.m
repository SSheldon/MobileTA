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

- (Student *)studentForSection:(Section *)section {
  for (Student *student in self.students) {
    if ([section isEqual:student.section]) {
      return student;
    }
  }

  return nil;
}

- (CGPoint)location {
  return CGPointMake(self.x, self.y);
}

- (void)setLocation:(CGPoint)location {
  self.x = location.x;
  self.y = location.y;
}

@end
