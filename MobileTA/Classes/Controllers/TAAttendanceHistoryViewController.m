//
//  TAAttendanceHistoryViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAAttendanceHistoryViewController.h"

#import "AttendanceRecord.h"
#import "Section.h"
#import "TAAttendanceRecordEditViewController.h"

@implementation TAAttendanceHistoryViewController

- (id)init {
  self = [self initWithStyle:UITableViewStylePlain];
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = NSLocalizedString(@"Meetings", nil);
    self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                    target:self
                                                    action:@selector(cancel)];
    self.navigationItem.rightBarButtonItems = @[
      self.editButtonItem,
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                    target:self
                                                    action:@selector(addNewAttendanceRecord)]
    ];
  }
  return self;
}

- (id)initWithSection:(Section *)section attendanceRecord:(AttendanceRecord *)record {
  self = [self initWithStyle:UITableViewStylePlain];
  if (self) {
    self.section = section;
    self.currentRecord = record;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.allowsSelectionDuringEditing = YES;
}

- (AttendanceRecord *)attendanceRecordAtIndexPath:(NSIndexPath *)indexPath {
  return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathOfAttendanceRecord:(AttendanceRecord *)record {
  return [self.fetchedResultsController indexPathForObject:record];
}

- (void)cancel {
  if ([self.delegate respondsToSelector:@selector(attendanceHistoryViewControllerDidCancel:)]) {
    [self.delegate attendanceHistoryViewControllerDidCancel:self];
  }
}

- (void)addNewAttendanceRecord {
  [self editAttendanceRecord:nil];
}

- (void)editAttendanceRecord:(AttendanceRecord *)record {
  TAAttendanceRecordEditViewController *controller = [[TAAttendanceRecordEditViewController alloc] initWithAttendanceRecord:record];
  controller.delegate = self;
  [self.navigationController pushViewController:controller animated:YES];
}

- (void)selectAttendanceRecord:(AttendanceRecord *)record {
  UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:[self indexPathOfAttendanceRecord:self.currentRecord]];
  oldCell.accessoryType = UITableViewCellAccessoryNone;

  self.currentRecord = ([self.currentRecord isEqual:record] ? nil : record);

  UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:[self indexPathOfAttendanceRecord:self.currentRecord]];
  newCell.accessoryType = UITableViewCellAccessoryCheckmark;

  if ([self.delegate respondsToSelector:@selector(attendanceHistoryViewController:didSelectAttendanceRecord:)]) {
    [self.delegate attendanceHistoryViewController:self didSelectAttendanceRecord:self.currentRecord];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Support all orientations
  return YES;
}

#pragma mark TAFetchedResultsTableViewController

- (NSFetchRequest *)fetchRequest {
  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
  fetch.entity = [NSEntityDescription entityForName:@"AttendanceRecord" inManagedObjectContext:self.managedObjectContext];
  fetch.predicate = [NSPredicate predicateWithFormat:@"section = %@", self.section];
  fetch.sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO],
  ];
  return fetch;
}

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath {
  AttendanceRecord *record = [self attendanceRecordAtIndexPath:indexPath];
  if ([self.delegate respondsToSelector:@selector(attendanceHistoryViewController:willDeleteAttendanceRecord:)]) {
    [self.delegate attendanceHistoryViewController:self willDeleteAttendanceRecord:record];
  }
  [super deleteObjectAtIndexPath:indexPath];
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *attendanceRecordCellId = @"AttendanceRecordCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attendanceRecordCellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:attendanceRecordCellId];
  }
  
  AttendanceRecord *record = [self attendanceRecordAtIndexPath:indexPath];
  cell.textLabel.text = [record description];
  cell.accessoryType = ([self.currentRecord isEqual:record] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
  
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  AttendanceRecord *record = [self attendanceRecordAtIndexPath:indexPath];
  if (self.editing) {
    [self editAttendanceRecord:record];
  } else {
    [self selectAttendanceRecord:record];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark TAAttendanceRecordEditDelegate

- (void)viewController:(TAAttendanceRecordEditViewController *)controller savedAttendanceRecord:(AttendanceRecord *)record withPreviousData:(NSDictionary *)oldData {
  if (!oldData) {
    record.section = self.section;
  }
  // Save changes to the record
  [self saveManagedObjectContext];
}

@end
