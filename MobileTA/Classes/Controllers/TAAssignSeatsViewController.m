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
  // Uncheck the cell for the old selected student
  UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:[self indexPathOfStudent:_selectedStudent]];
  oldCell.accessoryType = UITableViewCellAccessoryNone;

  // If we're selecting the same student, instead unselect them
  _selectedStudent = ([_selectedStudent isEqual:student] ? nil : student);

  // Check the cell for the new selected student
  UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:[self indexPathOfStudent:_selectedStudent]];
  newCell.accessoryType = UITableViewCellAccessoryCheckmark;

  if ([self.delegate respondsToSelector:@selector(assignSeatsViewController:didSelectStudent:forSeat:)]) {
    [self.delegate assignSeatsViewController:self didSelectStudent:_selectedStudent forSeat:self.seat];
  }
}

- (void)cancel {
  if ([self.delegate respondsToSelector:@selector(assignSeatsViewControllerDidCancel:)]) {
    [self.delegate assignSeatsViewControllerDidCancel:self];
  }
}

- (UITableViewCell *)createDisplayCellForStudent:(Student *)student {
  UITableViewCell *cell = [super createDisplayCellForStudent:student];
  cell.accessoryType = ([_selectedStudent isEqual:student] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
  return cell;
}

@end
