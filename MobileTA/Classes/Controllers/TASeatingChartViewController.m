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

#import "Room.h"
#import "Seat.h"
#import "Section.h"
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
  _section = section;

#if DEBUG
  if (section && !section.room.seats.count) {
    if (!section.room) {
      section.room = [Room roomWithContext:self.managedObjectContext];
    }
    // JUST FOR SHITS AND GIGGLES
    [section.room addSeatsObject:[Seat seatWithX:4 y:4 context:self.managedObjectContext]];
    [section.room addSeatsObject:[Seat seatWithX:10 y:8 context:self.managedObjectContext]];
    [self saveManagedObjectContext];
  }
#endif
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [_seatingChart setEditing:editing];
}

- (void)addSeat {
  Seat *seat = [Seat seatWithContext:self.managedObjectContext];
  Seat *lastSeat = [_seatingChart lastSeat];
  if (!lastSeat) {
    seat.x = 0;
    seat.y = 0;
  }
  else if (lastSeat.x <= 16) {
    seat.x = lastSeat.x + 4;
    seat.y = lastSeat.y;
  }
  else {
    seat.x = 0;
    seat.y = lastSeat.y + 4;
  }
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
