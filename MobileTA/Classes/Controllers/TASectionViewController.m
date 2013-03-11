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

@implementation TASectionViewController

- (id)init {
  self = [self initWithStyle:UITableViewStylePlain];
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
      self.title = NSLocalizedString(@"Roster", nil);
      UIBarButtonItem *newAttendanceRecordItem = [[UIBarButtonItem alloc] initWithTitle:@"Test"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(addNewAttendanceRecord)];
      self.navigationItem.rightBarButtonItems = @[
        newAttendanceRecordItem,
        self.editButtonItem,
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addNewStudent)],
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                      target:self
                                                      action:@selector(viewAttendanceHistory)]
      ];
      self.tableView.allowsSelectionDuringEditing = YES;
    }
    return self;
}

- (void)viewAttendanceHistory {
  TAAttendanceHistoryViewController *listViewController = [[TAAttendanceHistoryViewController alloc] initWithSection:self.section];

  [[self navigationController] pushViewController:listViewController animated:YES];
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
}

- (void)setSection:(Section *)section {
  _section = section;
  self.students = [section.students allObjects];
  self.title = section.name;
}

- (AttendanceRecord *)attendanceRecord {
  if (!_attendanceRecord && self.section) {
    _attendanceRecord = [AttendanceRecord attendanceRecordForSection:self.section context:self.managedObjectContext];
  }
  return _attendanceRecord;
}

- (StudentAttendance *)studentAttendanceForStudent:(Student *)student {
  for (StudentAttendance *attendance in self.attendanceRecord.studentAttendances) {
    if ([student isEqual:attendance.student]) {
      return attendance;
    }
  }

  StudentAttendance *attendance = [StudentAttendance studentAttendanceWithContext:self.managedObjectContext];
  attendance.attendanceRecord = self.attendanceRecord;
  attendance.student = student;
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

- (void)addNewAttendanceRecord {
  TAAttendanceRecordEditViewController *editViewController = [[TAAttendanceRecordEditViewController alloc] initWithAttendanceRecord:nil];
  [editViewController setDelegate:self];
  [self presentModalViewController:editViewController animated:YES];
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

#pragma mark TAStudentDetailCellDelegate

- (void)studentDetailCellDidMarkAbsent:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  attendance.status = [NSNumber numberWithInt:StudentAttendanceStatusAbsent];
  [self.managedObjectContext save:nil];
}

- (void)studentDetailCellDidMarkTardy:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  attendance.status = [NSNumber numberWithInt:StudentAttendanceStatusTardy];
  [self.managedObjectContext save:nil];
}

- (void)studentDetailCellDidAddParticipation:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  attendance.participation = [NSNumber numberWithInt:([attendance.participation intValue] + 1)];
  [self.managedObjectContext save:nil];
}

- (void)studentDetailCellDidSubtractParticipation:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  attendance.participation = [NSNumber numberWithInt:([attendance.participation intValue] - 1)];
  [self.managedObjectContext save:nil];
}

@end
