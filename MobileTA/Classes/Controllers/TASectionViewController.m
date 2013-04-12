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
      self.navigationItem.rightBarButtonItems = @[
        self.editButtonItem,
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addNewStudent)],
        [[UIBarButtonItem alloc] initWithTitle:@"History"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(viewAttendanceHistory)],
        [[UIBarButtonItem alloc] initWithTitle:@"Export"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(exportToCSV)],
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
  self.scrollView.hidden = (_segmentedControl.selectedSegmentIndex != TASectionSelectedViewSeatingChart);

  [self.view addSubview:_studentsController.tableView];
  _studentsController.tableView.hidden = (_segmentedControl.selectedSegmentIndex != TASectionSelectedViewTable);
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (!self.attendanceRecord && self.section) {
    // Find the record nearest now within 3 hours
    AttendanceRecord *record = [self.section attendanceRecordNearestToDate:[NSDate date]
                                                        withinTimeInterval:(3 * 60 * 60)];
    if (record) {
      self.attendanceRecord = record;
    }
  }
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
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
#if DEBUG
  // If this section is empty, populate it from the sample roster.
  if (!section.students.count) {
    NSArray *sampleStudents = [Student studentsFromCSV:[Student parseMyCSVFile] context:self.managedObjectContext];
    [section addStudents:[NSSet setWithArray:sampleStudents]];
    [self saveManagedObjectContext];
  }
#endif

  [super setSection:section];
  _studentsController.students = [section.students allObjects];
  self.title = section.name;
}

- (void)setAttendanceRecord:(AttendanceRecord *)attendanceRecord {
  [super setAttendanceRecord:attendanceRecord];
  if ([self isViewLoaded]) {
    [_studentsController.tableView reloadData];
  }
}

- (void)addNewStudent {
  switch (_segmentedControl.selectedSegmentIndex) {
    case TASectionSelectedViewTable:
      [self editStudent:nil];
      break;
    case TASectionSelectedViewSeatingChart:
      [self addSeat];
      break;
  }
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
  self.scrollView.hidden = (control.selectedSegmentIndex != TASectionSelectedViewSeatingChart);
  _studentsController.tableView.hidden = (control.selectedSegmentIndex != TASectionSelectedViewTable);
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

- (void)exportToCSV {
  if (![MFMailComposeViewController canSendMail]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Please set up email on your iPad."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    return;
  }

  // Write CSV for attachment
  NSOutputStream *output = [NSOutputStream outputStreamToMemory];
  [self.section writeCSVToOutputStream:output withAttendanceRecord:self.attendanceRecord];
  NSData *csvData = [output propertyForKey:NSStreamDataWrittenToMemoryStreamKey];

  NSString *subject = [NSString stringWithFormat:@"MobileTA: %@", [self.section displayName]];
  if (self.attendanceRecord) {
    subject = [subject stringByAppendingFormat:@" %@", [self.attendanceRecord getDescriptionShort]];
  }

  MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
  mailController.mailComposeDelegate = self;
  [mailController setSubject:subject];
  [mailController addAttachmentData:csvData mimeType:@"text/csv" fileName:@"roster.csv"];
  mailController.modalPresentationStyle = UIModalPresentationFormSheet;
  mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [self presentViewController:mailController animated:YES completion:nil];
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

- (void)attendanceHistoryViewController:(TAAttendanceHistoryViewController *)controller willDeleteAttendanceRecord:(AttendanceRecord *)record {
  if ([record isEqual:self.attendanceRecord]) {
    self.attendanceRecord = nil;
  }
}

- (void)attendanceHistoryViewControllerDidCancel:(TAAttendanceHistoryViewController *)controller {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TAStudentsAttendanceDelegate

- (void)viewController:(TAStudentsAttendanceViewController *)controller didSelectStudentToEdit:(Student *)student {
  [self editStudent:student];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
