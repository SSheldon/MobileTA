//
//  TAAssignSeatsViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 4/1/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAAssignSeatsViewController.h"

@interface TAAssignSeatsViewController ()

@end

@implementation TAAssignSeatsViewController
@synthesize students=_students;
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

- (void)setStudents:(NSArray *)students {
  _students = [students copy];
}

- (id)initWithSection:(Section *)section seat:(Seat *)seat {
    self = [self init];
    if (self) {
      _students = [[section students] copy];
      self.seat = seat;
      [self availableStudents];
    }
    return self;
}

- (void)selectStudent:(Student *)student {
  if ([self.delegate respondsToSelector:@selector(assignSeatsViewController:didSelectStudent:forSeat:)]) {
    [self.delegate assignSeatsViewController:self didSelectStudent:student forSeat:self.seat];
  }
}

- (void)availableStudents {
  NSMutableArray *studentsCopy = [self.students mutableCopy];
  for (Student *student in self.students) {
    // We don't want students that have already been assigned a seat to appear
    if (student.seat) {
      [studentsCopy removeObject:student];
    }
  }

  [self setStudents:studentsCopy];
  [super reloadStudents];
}

- (void)cancel {
  if ([self.delegate respondsToSelector:@selector(assignSeatsViewControllerDidCancel:)]) {
    [self.delegate assignSeatsViewControllerDidCancel:self];
  }
}

#pragma mark UITableViewDelegate

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
