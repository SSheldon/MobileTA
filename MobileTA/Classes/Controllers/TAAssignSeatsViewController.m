//
//  TAAssignSeatsViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 4/1/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAAssignSeatsViewController.h"

#import "Seat.h"

@implementation TAAssignSeatsViewController {
  Student *_selectedStudent;
}

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
      _selectedStudent = [seat studentForSection:section];
      self.seat = seat;
      self.students = [section.students allObjects];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.tableView selectRowAtIndexPath:[self indexPathOfStudent:_selectedStudent]
                              animated:NO
                        scrollPosition:UITableViewScrollPositionNone];
}

- (void)setStudents:(NSArray *)students {
  NSMutableArray *seatlessStudents = [NSMutableArray array];
  for (Student *student in students) {
    // We don't want students that have already been assigned a seat to appear
    if (!student.seat || [_selectedStudent isEqual:student]) {
      [seatlessStudents addObject:student];
    }
  }

  [super setStudents:seatlessStudents];
}

- (void)selectStudent:(Student *)student {
  _selectedStudent = student;
  if ([self.delegate respondsToSelector:@selector(assignSeatsViewController:didSelectStudent:forSeat:)]) {
    [self.delegate assignSeatsViewController:self didSelectStudent:student forSeat:self.seat];
  }
}

- (void)cancel {
  if ([self.delegate respondsToSelector:@selector(assignSeatsViewControllerDidCancel:)]) {
    [self.delegate assignSeatsViewControllerDidCancel:self];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Student *student = [self studentAtIndexPath:indexPath];
  if ([_selectedStudent isEqual:student]) {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self selectStudent:nil];
  } else {
    [self selectStudent:student];
  }
}

@end
