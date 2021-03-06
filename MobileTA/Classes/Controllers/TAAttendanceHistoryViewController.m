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

@implementation TAAttendanceHistoryViewController {
 NSMutableArray *_tableSections;
}

@synthesize records = _records;

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
  self = [super init];
  if (self) {
    self.section = section;
    self.records = [section.attendanceRecords allObjects];
    self.currentRecord = record;
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)setRecords:(NSArray *)records {
  // Sort the records by date
  NSArray *sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]
  ];
  _records = [records sortedArrayUsingDescriptors:sortDescriptors];

  if ([self isViewLoaded]) {
    [self.tableView reloadData];
  }
}

- (AttendanceRecord *)attendanceRecordAtIndexPath:(NSIndexPath *)indexPath {
  return [[self records] objectAtIndex:[indexPath row]];
}

- (NSIndexPath *)indexPathOfAttendanceRecord:(AttendanceRecord *)record {
  NSUInteger index = [self.records indexOfObject:record];
  if (index == NSNotFound) {
    return nil;
  }
  return [NSIndexPath indexPathForRow:index inSection:0];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return [[self records] count];
}

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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if(editingStyle == UITableViewCellEditingStyleDelete) {
    AttendanceRecord *record = [self attendanceRecordAtIndexPath:indexPath];
    // Remove record from the Records array
    NSMutableArray *mutableRecords = [_records mutableCopy];
    [mutableRecords removeObject:record];
    _records = [mutableRecords copy];
    // Remove the corresponding row from the table
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    // Inform the delegate
    if ([self.delegate respondsToSelector:@selector(attendanceHistoryViewController:willDeleteAttendanceRecord:)]) {
      [self.delegate attendanceHistoryViewController:self willDeleteAttendanceRecord:record];
    }
    // Remove record from the database
    [[self managedObjectContext] deleteObject:record];
    [self saveManagedObjectContext];
  }
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

  if (!oldData) {
    // Add the new record to the table
    self.records = [self.records arrayByAddingObject:record];
    // Select the new record
    [self selectAttendanceRecord:record];
  } else {
    // Re-sort the table
    self.records = [self.records copy];
  }
}

@end
