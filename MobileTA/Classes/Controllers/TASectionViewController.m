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

@implementation TASectionViewController

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
    [self saveManagedObjectContext];
    self.students = sampleStudents;
  }
#endif

  if (!self.attendanceRecord && self.section) {
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

- (void)setAttendanceRecord:(AttendanceRecord *)attendanceRecord {
  _attendanceRecord = attendanceRecord;
  if ([self isViewLoaded]) {
    [self.tableView reloadData];
  }
  self.title = [NSString stringWithFormat:@"%@  (%@)", self.section.name, [self.attendanceRecord getDescriptionShort]];
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
    self.title = [NSString stringWithFormat:@"%@  (%@ *new*)", self.section.name, [self.attendanceRecord getDescriptionShort]];
  }
  return attendance;
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
  [seatingChart setAttendanceRecord:self.attendanceRecord];
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

#pragma mark TAStudentEditDelegate

- (void)viewController:(TAStudentEditViewController *)viewController savedStudent:(Student *)student withPreviousData:(NSDictionary *)oldData {
  if (!oldData) {
    // Make sure that the section for the student is the correct section
    student.section = self.section;
  }
  // Save changes to the student
  [self saveManagedObjectContext];
  // Update the table based on these changes
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

#pragma mark TAStudentsAttendanceViewController

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
  return attendance.status;
}

- (int16_t)changeParticipationBy:(int16_t)value forStudent:(Student *)student {
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  attendance.participation += value;
  [self saveManagedObjectContext];
  return attendance.participation;
}

- (void)selectStudentToEdit:(Student *)student {
  [self editStudent:student];
}

@end
