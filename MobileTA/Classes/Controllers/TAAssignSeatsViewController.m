//
//  TAAssignSeatsViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 4/1/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAAssignSeatsViewController.h"

@implementation TAAssignSeatsViewController

- (id)init {
  self = [self initWithStyle:UITableViewStylePlain];
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = NSLocalizedString(@"Students", nil);
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(cancel)];
  }
  return self;
}

- (id)initWithSection:(Section *)section seat:(Seat *)seat {
    self = [self init];
    if (self) {
      self.seat = seat;
      self.students = [section.students allObjects];
    }
    return self;
}

- (void)selectStudent:(Student *)student {
  if ([self.delegate respondsToSelector:@selector(assignSeatsViewController:didSelectStudent:forSeat:)]) {
    [self.delegate assignSeatsViewController:self didSelectStudent:student forSeat:self.seat];
  }
}

- (void)setStudents:(NSArray *)students {
  NSMutableArray *seatlessStudents = [NSMutableArray array];
  for (Student *student in students) {
    // We don't want students that have already been assigned a seat to appear
    if (!student.seat) {
      [seatlessStudents addObject:student];
    }
  }

  [super setStudents:seatlessStudents];
}

- (void)cancel {
  if ([self.delegate respondsToSelector:@selector(assignSeatsViewControllerDidCancel:)]) {
    [self.delegate assignSeatsViewControllerDidCancel:self];
  }
}

@end
