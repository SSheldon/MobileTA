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
#import "TAStudentsGroupsViewController.h"

typedef NS_ENUM(NSInteger, TASectionSelectedViewType) {
  TASectionSelectedViewTable,
  TASectionSelectedViewGroups,
  TASectionSelectedViewSeatingChart
};

@interface TASectionViewController ()
@property (strong, nonatomic) UIActionSheet *actionSheet;
@end

@implementation TASectionViewController {
  TAStudentsAttendanceViewController *_studentsController;
  TAStudentsGroupsViewController *_groupsController;
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
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                      target:self
                                                      action:@selector(showActionSheet:event:)]
      ];

      _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Roster", @"Groups", @"Seating Chart"]];
      _segmentedControl.selectedSegmentIndex = TASectionSelectedViewTable;
      _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
      [_segmentedControl addTarget:self action:@selector(segmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
      self.navigationItem.titleView = _segmentedControl;

      _studentsController = [[TAStudentsAttendanceViewController alloc] initWithStyle:UITableViewStylePlain];
      [self addChildViewController:_studentsController];
      [_studentsController didMoveToParentViewController:self];
      _studentsController.delegate = self;

      _groupsController = [[TAStudentsGroupsViewController alloc] initWithStyle:UITableViewStylePlain];
      [self addChildViewController:_groupsController];
      [_groupsController didMoveToParentViewController:self];
      _groupsController.delegate = self;
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
  _studentsController.tableView.allowsSelectionDuringEditing = YES;

  [self.view addSubview:_groupsController.tableView];
  _groupsController.tableView.hidden = (_segmentedControl.selectedSegmentIndex != TASectionSelectedViewGroups);
  _groupsController.tableView.allowsSelectionDuringEditing = YES;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
  // In iOS7 our views lay out under the nav bar, so the insets of our scroll views need to be updated.
  // The seating chart scroll view is covered by automaticallyAdjustsScrollViewInsets, but apparently
  // our table views aren't, so we must manually inset them.
  if ([self respondsToSelector:@selector(edgesForExtendedLayout)] &&
      (self.edgesForExtendedLayout & UIRectEdgeTop) == UIRectEdgeTop) {
    CGFloat navBarBottom = CGRectGetMaxY(self.navigationController.navigationBar.frame);

    [self _updateScrollView:_studentsController.tableView withTopInset:navBarBottom];
    [self _updateScrollView:_groupsController.tableView withTopInset:navBarBottom];
  }
#endif
}

- (void)_updateScrollView:(UIScrollView *)scrollView withTopInset:(CGFloat)topInset {
  UIEdgeInsets inset = scrollView.contentInset;
  inset.top += topInset;
  scrollView.contentInset = inset;

  CGPoint offset = scrollView.contentOffset;
  offset.y -= topInset;
  scrollView.contentOffset = offset;
}

- (void)selectRandomStudent {
  Student *student = [self.section randomStudent];
  NSString *message = [student fullDisplayName];
  if (student.group) {
    message = [message stringByAppendingFormat:@"\n%@", student.group.name];
  }
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The victim is..."
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
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

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:animated];
  self.actionSheet = nil;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  _studentsController.tableView.frame = self.view.bounds;
  _groupsController.tableView.frame = self.view.bounds;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Support all orientations
  return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  for (UIViewController *controller in self.childViewControllers) {
    [controller setEditing:editing animated:animated];
  }
}

- (void)setSection:(Section *)section {
#if DEBUG
  // If this section is empty, populate it from the sample roster.
  if (section && !section.students.count) {
    NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"roster" ofType:@"csv"];
    NSArray *sampleStudents = [Student studentsFromCSVFile:csvFilePath context:self.managedObjectContext];
    [section addStudents:[NSSet setWithArray:sampleStudents]];
    [self saveManagedObjectContext];
  }
#endif

  [super setSection:section];
  _studentsController.section = section;
  _groupsController.section = section;
  self.title = section.name;
}

- (void)setAttendanceRecord:(AttendanceRecord *)attendanceRecord {
  [super setAttendanceRecord:attendanceRecord];
  if ([self isViewLoaded]) {
    [_studentsController.tableView reloadData];
    [_groupsController.tableView reloadData];
  }
}

- (void)addNewStudent {
  if (_segmentedControl.selectedSegmentIndex == TASectionSelectedViewSeatingChart) {
    [self addSeat];
  } else {
    [self editStudent:nil];
  }
}

- (void)editStudent:(Student *)student {
  TAStudentEditViewController *editViewController = [[TAStudentEditViewController alloc] initWithStudent:student inSection:[self section]];
  editViewController.delegate = self;
  [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)segmentedControlDidChange:(UISegmentedControl *)control {
  self.scrollView.hidden = (control.selectedSegmentIndex != TASectionSelectedViewSeatingChart);
  _studentsController.tableView.hidden = (control.selectedSegmentIndex != TASectionSelectedViewTable);
  _groupsController.tableView.hidden = (control.selectedSegmentIndex != TASectionSelectedViewGroups);
}

- (void)viewGroups {
  TAGroupsViewController *groupsViewController = [[TAGroupsViewController alloc] initWithSection:self.section];
  groupsViewController.delegate = self;
  TANavigationController *navController = [[TANavigationController alloc] initWithRootViewController:groupsViewController];
  navController.disablesAutomaticKeyboardDismissal = NO;
  navController.modalPresentationStyle = UIModalPresentationFormSheet;
  navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  
  [self presentViewController:navController animated:YES completion:nil];
}

- (void)viewAttendanceHistory {
  TAAttendanceHistoryViewController *listViewController = [[TAAttendanceHistoryViewController alloc] initWithSection:self.section attendanceRecord:self.attendanceRecord];
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

- (void)showActionSheet:(UIBarButtonItem *)sender event:(UIEvent *)event {
  if (self.actionSheet) {
    [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:YES];
    self.actionSheet = nil;
    return;
  }

  self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Choose Random Student", @"Manage Groups", @"Manage Meetings", @"Export", nil];
  [self.actionSheet showFromBarButtonItem:sender animated:YES];
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
}

- (void)attendanceHistoryViewController:(TAAttendanceHistoryViewController *)controller willDeleteAttendanceRecord:(AttendanceRecord *)record {
  if ([record isEqual:self.attendanceRecord]) {
    self.attendanceRecord = nil;
  }
}

- (void)attendanceHistoryViewControllerDidCancel:(TAAttendanceHistoryViewController *)controller {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark TAGroupsViewControllerDelegate

- (void)groupsViewControllerDidCancel:(TAGroupsViewController *)groupsViewController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)groupsViewController:(TAGroupsViewController *)controller didUpdateGroup:(Group *)group {
  // Reload the groups
  [self.seatingChart reloadSeats];
}

- (void)groupsViewController:(TAGroupsViewController *)controller didRemoveGroup:(Group *)group {
  // Reload the groups
  [self.seatingChart reloadSeats];
}

#pragma mark TAStudentsAttendanceDelegate

- (void)viewController:(TAStudentsAttendanceViewController *)controller didSelectStudentToEdit:(Student *)student {
  [self editStudent:student];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  // Unfortunately there is no way for me to have a dictionary provide the titles
  // for the actionSheet (or I would do a mapping), and I can't store selectors
  // in arrays, so I am doing it the old fashion way
  switch (buttonIndex) {
    case 0: [self selectRandomStudent];
    break;
    case 1: [self viewGroups];
    break;
    case 2: [self viewAttendanceHistory];
    break;
    case 3: [self exportToCSV];
    break;
    default:
    break;
  }
  self.actionSheet = nil;
}

@end
