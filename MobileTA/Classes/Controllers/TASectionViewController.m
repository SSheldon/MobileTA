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
#import "TANavigationController.h"

typedef NS_ENUM(NSInteger, TASectionSelectedViewType) {
  TASectionSelectedViewTable,
  TASectionSelectedViewSeatingChart
};

@implementation TASectionViewController {
  TAStudentsAttendanceViewController *_studentsController;
  UISegmentedControl *_segmentedControl;
}

- (id)init {
  self = [self initWithNibName:nil bundle:nil];
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.title = NSLocalizedString(@"Roster", nil);
      self.navigationItem.rightBarButtonItems = @[
        self.editButtonItem,
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addNewStudent)],
        [[UIBarButtonItem alloc] initWithTitle:@"History"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(viewAttendanceHistory)]
      ];

      _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Roster", @"Seating Chart"]];
      _segmentedControl.selectedSegmentIndex = TASectionSelectedViewTable;
      _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
      [_segmentedControl addTarget:self action:@selector(segmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
      self.navigationItem.titleView = _segmentedControl;

      _studentsController = [[TAStudentsAttendanceViewController alloc] initWithStyle:UITableViewStylePlain];
      [self addChildViewController:_studentsController];
      [_studentsController didMoveToParentViewController:self];
      _studentsController.delegate = self;
      _studentsController.tableView.allowsSelectionDuringEditing = YES;
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
  [self.view addSubview:_studentsController.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

#if DEBUG
  // If this section is empty, populate it from the sample roster.
  if (!self.section.students.count) {
    NSArray *sampleStudents = [Student studentsFromCSV:[Student parseMyCSVFile] context:self.managedObjectContext];
    [self.section addStudents:[NSSet setWithArray:sampleStudents]];
    [self saveManagedObjectContext];
    _studentsController.students = sampleStudents;
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

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  self.scrollView.hidden = YES;
  _studentsController.tableView.frame = self.view.frame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Support all orientations
  return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  [_studentsController setEditing:editing animated:animated];
}

- (void)setSection:(Section *)section {
  [super setSection:section];
  _studentsController.students = [section.students allObjects];
  self.title = section.name;
}

- (void)setAttendanceRecord:(AttendanceRecord *)attendanceRecord {
  [super setAttendanceRecord:attendanceRecord];
  if ([self isViewLoaded]) {
    [_studentsController.tableView reloadData];
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
      NSMutableArray *new_students = [NSMutableArray arrayWithArray:_studentsController.students];
      [new_students addObject:student];
      _studentsController.students = new_students;
    } else {
      [_studentsController reloadStudents];
    }
  }
}

- (void)segmentedControlDidChange:(UISegmentedControl *)control {
  switch (control.selectedSegmentIndex) {
    case TASectionSelectedViewTable:
      self.scrollView.hidden = YES;
      _studentsController.tableView.hidden = NO;
      break;
    case TASectionSelectedViewSeatingChart:
      _studentsController.tableView.hidden = YES;
      self.scrollView.hidden = NO;
      break;
  }
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
  return attendance.status;
}

- (int16_t)changeParticipationBy:(int16_t)value forStudent:(Student *)student {
  StudentAttendance *attendance = [self studentAttendanceForStudent:student];
  attendance.participation += value;
  [self saveManagedObjectContext];
  return attendance.participation;
}

- (void)viewController:(TAStudentsAttendanceViewController *)controller didSelectStudentToEdit:(Student *)student {
  [self editStudent:student];
}

@end
