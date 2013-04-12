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
  _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
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
  Seat *lastSeat = [_seatingChart lastSeat];
  int16_t x = 0;
  int16_t y = 0;
  if (lastSeat) {
    x = lastSeat.x;
    y = lastSeat.y;
  }
  while (![self.section.room canAddSeatAtX:x y:y]) {
    x += 4;
    if (x > 20) {
      x = 0;
      y += 4;
    }
  }
  Seat *seat = [Seat seatWithContext:self.managedObjectContext];
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
      AttendanceRecord *record = [AttendanceRecord attendanceRecordWithContext:self.managedObjectContext];
      record.section = self.section;
      self.attendanceRecord = record;
    }
    attendance = [StudentAttendance studentAttendanceWithContext:self.managedObjectContext];
    attendance.attendanceRecord = self.attendanceRecord;
    attendance.student = student;
    [self saveManagedObjectContext];
  }
  return attendance;
}

#pragma mark Private Methods

- (void)showAssignSeatDialogForSeat:(Seat *)seat {
  TAAssignSeatsViewController *studentsViewController = [[TAAssignSeatsViewController alloc] initWithSection:self.section seat:seat];
  TANavigationController *navController = [[TANavigationController alloc] initWithRootViewController:studentsViewController];
  [studentsViewController setDelegate:self];
  navController.disablesAutomaticKeyboardDismissal = NO;
  navController.modalPresentationStyle = UIModalPresentationFormSheet;
  navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)showAttendanceInformationPopoverForSeat:(Seat *)seat {
  Student *student = [seat studentForSection:_section];
  if (!student) {
    return;
  }
  StudentAttendance *studentAttendance = [_attendanceRecord studentAttendanceForStudent:student];
  TASeatingChartAttendanceViewController *controller = [[TASeatingChartAttendanceViewController alloc] initWithStudentAttendance:studentAttendance];
  _attendancePopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
  [_attendancePopoverController setPopoverContentSize:CGSizeMake(400, 500)];
  TASeatView *attachedSeat = [_seatingChart seatViewForSeat:seat];
  [_attendancePopoverController presentPopoverFromRect:[attachedSeat frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  [self saveManagedObjectContext];
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return _seatingChart;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
  
}

#pragma mark TASeatingChartView

- (void)didDeleteSeat:(Seat *)seat {
  [self.managedObjectContext deleteObject:seat];
  [self saveManagedObjectContext];
}

- (void)didMoveSeat:(Seat *)seat toLocation:(CGPoint)location {
  [seat setLocation:location];
  [self saveManagedObjectContext];
}

- (void)didSelectSeat:(Seat *)seat {
  if ([_seatingChart isEditing]) {
    [self showAssignSeatDialogForSeat:seat];
  }
  else {
    [self showAttendanceInformationPopoverForSeat:seat];
  }
}

- (Seat *)seatForLocation:(CGPoint)location {
  if (![self.section.room canAddSeatAtLocation:location]) {
    return nil;
  }

  Seat *seat = [Seat seatWithContext:self.managedObjectContext];
  [seat setLocation:location];
  [self.section.room addSeatsObject:seat];
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

#pragma mark TAStudentsAttendanceDelegate

- (StudentAttendanceStatus)statusForStudent:(Student *)student {
  return [self.attendanceRecord studentAttendanceForStudent:student].status;
}
- (int16_t)particpationForStudent:(Student *)student {
  return [self.attendanceRecord studentAttendanceForStudent:student].participation;
}

- (StudentAttendanceStatus)markStatus:(StudentAttendanceStatus)status forStudent:(Student *)student {
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  if (attendance.status == status) {
    attendance.status = StudentAttendanceStatusPresent;
  }
  else {
    attendance.status = status;
  }
  [self saveManagedObjectContext];

  // If this student is on the seating chart, reload their view
  if (student.seat) {
    [self.seatingChart setStudent:student forSeat:student.seat];
  }

  return attendance.status;
}

- (int16_t)changeParticipationBy:(int16_t)value forStudent:(Student *)student {
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  attendance.participation += value;
  [self saveManagedObjectContext];

  // If this student is on the seating chart, reload their view
  if (student.seat) {
    [self.seatingChart setStudent:student forSeat:student.seat];
  }

  return attendance.participation;
}

@end
