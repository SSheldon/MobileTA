//
//  TASectionViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 3/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASectionViewController.h"

#import "AttendanceRecord.h"
#import "StudentAttendance.h"
#import "TASeatingChartViewController.h"
#import "TANavigationController.h"

@implementation TASectionViewController {
  AttendanceRecord *_attendanceRecord;
}

- (id)init {
  self = [self initWithStyle:UITableViewStylePlain];
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
      self.title = NSLocalizedString(@"Roster", nil);
      UIBarButtonItem *attendanceHistoryItem = [[UIBarButtonItem alloc] initWithTitle:@"History"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(viewAttendanceHistory)];
      self.navigationItem.rightBarButtonItems = @[
        self.editButtonItem,
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addNewStudent)],
        attendanceHistoryItem,
        [[UIBarButtonItem alloc] initWithTitle:@"Test"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(viewSeatingChart)]
      ];
      self.tableView.allowsSelectionDuringEditing = YES;
    }
    return self;
}

- (id)initWithSection:(Section *)section {
  self = [super init];
  if (self) {
    self.section = section;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

#if DEBUG
  // If this section is empty, populate it from the sample roster.
  if (!self.section.students.count) {
    NSArray *sampleStudents = [Student studentsFromCSV:[Student parseMyCSVFile] context:self.managedObjectContext];
    [self.section addStudents:[NSSet setWithArray:sampleStudents]];
    [self.managedObjectContext save:nil];
    self.students = sampleStudents;
  }
#endif

  if (!_attendanceRecord && self.section) {
    // Find the record nearest now within 40 minutes
    AttendanceRecord *record = [self.section attendanceRecordNearestToDate:[NSDate date]
                                                        withinTimeInterval:(40 * 60)];
    if (record) {
      self.attendanceRecord = record;
    }
  }
}

- (void)setSection:(Section *)section {
  _section = section;
  self.students = [section.students allObjects];
  self.title = section.name;
}

- (AttendanceRecord *)attendanceRecord {
  if (!_attendanceRecord && self.section) {
    _attendanceRecord = [AttendanceRecord attendanceRecordForSection:self.section context:self.managedObjectContext];
    _attendanceRecord.date = [NSDate date];
  }
  return _attendanceRecord;
}

- (void)setAttendanceRecord:(AttendanceRecord *)attendanceRecord {
  _attendanceRecord = attendanceRecord;
  if ([self isViewLoaded]) {
    [self.tableView reloadData];
  }
  self.title = [NSString stringWithFormat:@"%@  (%@)", _section.name, [_attendanceRecord getDescriptionShort]];
}

- (StudentAttendance *)studentAttendanceForStudent:(Student *)student {
  StudentAttendance *attendance = [self.attendanceRecord studentAttendanceForStudent:student];
  if (!attendance) {
    attendance = [StudentAttendance studentAttendanceWithContext:self.managedObjectContext];
    attendance.attendanceRecord = self.attendanceRecord;
    attendance.student = student;
    [self.managedObjectContext save:nil];
    self.title = [NSString stringWithFormat:@"%@  (%@ *new*)", _section.name, [_attendanceRecord getDescriptionShort]];
  }
  return attendance;
}

- (void)selectStudent:(Student *)student {
  if(self.tableView.editing) {
    [self editStudent:student];
  }
  else {
    [self showDetailsForStudent:student];
  }
}

- (void)addNewStudent {
  [self editStudent:nil];
}

- (void)editStudent:(Student *)student {
  TAStudentEditViewController *editViewController = [[TAStudentEditViewController alloc] initWithStudent:student];
  editViewController.delegate = self;
  [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)updateStudent:(Student *)student withPreviousData:(NSDictionary *)oldData {
  if (student.lastName != [oldData objectForKey:@"lastName"] ||
      student.nickname != [oldData objectForKey:@"nickname"] ||
      student.firstName != [oldData objectForKey:@"firstName"]) {
    if (!oldData) {
      // Make sure that the section for the student is the correct section
      student.section = self.section;
      [[self managedObjectContext] save:nil];
      // Add the student
      NSMutableArray *new_students = [NSMutableArray arrayWithArray:self.students];
      [new_students addObject:student];
      self.students = new_students;
    } else {
      [self reloadStudents];
    }
  }
}

- (void)viewSeatingChart {
  TASeatingChartViewController *seatingChart = [[TASeatingChartViewController alloc] initWithSection:self.section];
  [seatingChart setAttendanceRecord:_attendanceRecord];
  [[self navigationController] pushViewController:seatingChart animated:YES];
}

- (void)viewAttendanceHistory {
  TAAttendanceHistoryViewController *listViewController = [[TAAttendanceHistoryViewController alloc] initWithSection:self.section];
  listViewController.delegate = self;

  TANavigationController *navController = [[TANavigationController alloc] initWithRootViewController:listViewController];
  navController.disablesAutomaticKeyboardDismissal = NO;
  navController.modalPresentationStyle = UIModalPresentationFormSheet;
  navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;

  [self presentViewController:navController animated:YES completion:nil];
}

- (UITableViewCell *)createDisplayCellForStudent:(Student *)student {
  static NSString *studentDisplayCellId = @"StudentDisplayCell";
  TAStudentDisplayCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:studentDisplayCellId];
  if (!cell) {
    cell = [[TAStudentDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentDisplayCellId];
  }
  [cell setController:self];
  cell.textLabel.text = student.fullDisplayName;
  if (_attendanceRecord) {
    StudentAttendance *attendance = [_attendanceRecord studentAttendanceForStudent:student];
    [cell setStatus:attendance.status];
    [cell setParticipation:attendance.participation];
  }
  return cell;
}

- (UITableViewCell *)createDetailCellForStudent:(Student *)student {
  static NSString *studentDetailCellId = @"StudentDetailCell";
  TAStudentDetailCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:studentDetailCellId];
  if (!cell) {
    cell = [[TAStudentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentDetailCellId];
  }
  [cell setController:self];
//  cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
  
  return cell;
}

#pragma mark TAStudentEditDelegate

- (void)viewController:(TAStudentEditViewController *)viewController savedStudent:(Student *)student withPreviousData:(NSDictionary *)oldData {
  [self updateStudent:student withPreviousData:oldData];
}

#pragma mark TAAttendanceHistoryDelegate

- (void)attendanceHistoryViewController:(TAAttendanceHistoryViewController *)controller didSelectAttendanceRecord:(AttendanceRecord *)record {
  self.attendanceRecord = record;
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)attendanceHistoryViewControllerDidCancel:(TAAttendanceHistoryViewController *)controller {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TAStudentDetailCellDelegate

- (void)studentDetailCellDidMarkAbsent:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  if (attendance.status == StudentAttendanceStatusAbsent) {
    attendance.status = StudentAttendanceStatusPresent;
  }
  else {
    attendance.status = StudentAttendanceStatusAbsent;
  }
  UITableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:detailedStudentIndex];
  if([tableViewCell isKindOfClass:[TAStudentDisplayCell class]]) {
    TAStudentDisplayCell *displayCell = (TAStudentDisplayCell *)tableViewCell;
    [displayCell setStatus:attendance.status];
  }
  [self.managedObjectContext save:nil];
}

- (void)studentDetailCellDidMarkTardy:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  if (attendance.status == StudentAttendanceStatusTardy) {
    attendance.status = StudentAttendanceStatusPresent;
  }
  else {
    attendance.status = StudentAttendanceStatusTardy;
  }
  UITableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:detailedStudentIndex];
  if([tableViewCell isKindOfClass:[TAStudentDisplayCell class]]) {
    TAStudentDisplayCell *displayCell = (TAStudentDisplayCell *)tableViewCell;
    [displayCell setStatus:attendance.status];
  }
  [self.managedObjectContext save:nil];
}

- (void)studentDetailCellDidAddParticipation:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  if (attendance.participation >= 2) {
    return;
  }
  attendance.participation++;
  UITableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:detailedStudentIndex];
  if([tableViewCell isKindOfClass:[TAStudentDisplayCell class]]) {
    TAStudentDisplayCell *displayCell = (TAStudentDisplayCell *)tableViewCell;
    [displayCell setParticipation:attendance.participation];
  }
  [self.managedObjectContext save:nil];
}

- (void)studentDetailCellDidSubtractParticipation:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  if (attendance.participation <= 0) {
    return;
  }
  attendance.participation--;
  UITableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:detailedStudentIndex];
  if([tableViewCell isKindOfClass:[TAStudentDisplayCell class]]) {
    TAStudentDisplayCell *displayCell = (TAStudentDisplayCell *)tableViewCell;
    [displayCell setParticipation:attendance.participation];
  }
  [self.managedObjectContext save:nil];
}

@end
