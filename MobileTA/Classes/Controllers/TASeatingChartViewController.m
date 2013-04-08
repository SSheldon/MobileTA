//
//  TASeatingChartViewController.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatingChartViewController.h"
#import "TANavigationController.h"
#import "TAStudentsViewController.h"
#import "TAAssignSeatsViewController.h"
#import "TAGridConstants.h"

#import "Room.h"
#import "Seat.h"
#import "Section.h"
#import "StudentAttendance.h"
#import "AttendanceRecord.h"

@implementation TASeatingChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
  }
  return self;
}

- (id)initWithSection:(Section *)section {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    self.section = section;
  }
  return self;
}

- (void)loadView {
  [super loadView];

  // Make a scroll view
  _scrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
  [_scrollView setContentSize:[TASeatingChartView roomPixelSize]];
  // The highest they can zoom is double the size
  [_scrollView setMaximumZoomScale:2.0];
  // The lowest they can zoom is 1/4 the size
  [_scrollView setMinimumZoomScale:0.4];
  [_scrollView setDelegate:self];

  // Make a seating chart that fills the entire view
  _seatingChart = [[TASeatingChartView alloc] initWithSection:self.section];
  _seatingChart.attendanceRecord = self.attendanceRecord;
  [_seatingChart setDelegate:self];
  for (Seat *seat in self.section.room.seats) {
    [_seatingChart addSeat:seat];
  }

  [_scrollView addSubview:_seatingChart];
  [[self view] addSubview:_scrollView];
}

- (void)setSection:(Section *)section {
  // Create a room for this section if it doesn't have one
  if (section && !section.room) {
    section.room = [Room roomWithContext:self.managedObjectContext];
#if DEBUG
    // JUST FOR SHITS AND GIGGLES
    [section.room addSeatsObject:[Seat seatWithX:4 y:4 context:self.managedObjectContext]];
    [section.room addSeatsObject:[Seat seatWithX:10 y:8 context:self.managedObjectContext]];
#endif
    [self saveManagedObjectContext];
  }

  _section = section;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [_seatingChart setEditing:editing];
}

- (void)addSeat {
  Seat *seat = [Seat seatWithContext:self.managedObjectContext];
  Seat *lastSeat = [_seatingChart lastSeat];
  int16_t x = 0;
  int16_t y = 0;
  if (lastSeat) {
    x = lastSeat.x;
    y = lastSeat.y;
  }
  while (![_seatingChart canMoveSeat:seat toPoint:CGPointMake(u2p(x), u2p(y))]) {
    x += 4;
    if (x > 20) {
      x = 0;
      y += 4;
    }
  }
  seat.x = x;
  seat.y = y;
  [self.section.room addSeatsObject:seat];
  [self saveManagedObjectContext];
  [_seatingChart addSeat:seat];
}

- (void)setAttendanceRecord:(AttendanceRecord *)attendanceRecord {
  _attendanceRecord = attendanceRecord;
  // TODO(srice): Based on the fact that this function exists, I imagine we are
  // violating MVC pretty heavily. At some point, I should refactor this to
  // be more MVC friendly.
  [_seatingChart setAttendanceRecord:attendanceRecord];
}

- (StudentAttendance *)studentAttendanceForStudent:(Student *)student {
  StudentAttendance *attendance = [self.attendanceRecord studentAttendanceForStudent:student];
  if (!attendance) {
    // If we don't currently have an attendance record, create one
    if (!self.attendanceRecord) {
      _attendanceRecord = [AttendanceRecord attendanceRecordWithContext:self.managedObjectContext];
      _attendanceRecord.section = self.section;
    }
    attendance = [StudentAttendance studentAttendanceWithContext:self.managedObjectContext];
    attendance.attendanceRecord = self.attendanceRecord;
    attendance.student = student;
    [self saveManagedObjectContext];
  }
  return attendance;
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return _seatingChart;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
  
}

#pragma mark TASeatingChartView

- (void)didAddSeat:(Seat *)seat {
  [[[self section] room] addSeatsObject:seat];
  [seat setRoom:self.section.room];
  [self saveManagedObjectContext];
}

- (void)didDeleteSeat:(Seat *)seat {
  [self.managedObjectContext deleteObject:seat];
  [self saveManagedObjectContext];
}

- (void)didMoveSeat:(Seat *)seat toLocation:(CGPoint)location {
  [seat setLocation:location];
  [self saveManagedObjectContext];
}

- (void)didSelectSeat:(Seat *)seat {
  TAAssignSeatsViewController *studentsViewController = [[TAAssignSeatsViewController alloc] initWithSection:self.section seat:seat];
  TANavigationController *navController = [[TANavigationController alloc] initWithRootViewController:studentsViewController];
  [studentsViewController setDelegate:self];
  navController.disablesAutomaticKeyboardDismissal = NO;
  navController.modalPresentationStyle = UIModalPresentationFormSheet;
  navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [self presentViewController:navController animated:YES completion:nil];
}

- (Seat *)seatForLocation:(CGPoint)location {
  Seat *seat = [Seat seatWithContext:self.managedObjectContext];
  [self.section.room addSeatsObject:seat];
  [seat setLocation:location];
  [self saveManagedObjectContext];
  return seat;
}

#pragma mark TAAssignSeatsViewDelegate
- (void)assignSeatsViewController:(TAAssignSeatsViewController*)controller didSelectStudent:(Student *)student forSeat:(Seat *)seat {
  // assign student to seat view
  [seat setStudent:student forSection:self.section];

  [self saveManagedObjectContext];
  [_seatingChart setStudent:student forSeat:seat];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)assignSeatsViewControllerDidCancel:(TAAssignSeatsViewController *)controller {
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
