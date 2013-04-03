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

@interface TAAttendanceHistoryViewController ()

@end

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
    self.title = NSLocalizedString(@"Attendance History", nil);
    self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                    target:self
                                                    action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                    target:self
                                                    action:@selector(addNewAttendanceRecord)];
  }
  return self;
}

- (id)initWithSection:(Section *)section {
  self = [super init];
  if (self) {
    self.section = section;
    self.records = [section.attendanceRecords allObjects];
  }
  return self;
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

- (void)cancel {
  if ([self.delegate respondsToSelector:@selector(attendanceHistoryViewControllerDidCancel:)]) {
    [self.delegate attendanceHistoryViewControllerDidCancel:self];
  }
}

- (void)addNewAttendanceRecord {
  TAAttendanceRecordEditViewController *controller = [[TAAttendanceRecordEditViewController alloc] initWithAttendanceRecord:nil];
  controller.delegate = self;
  [self.navigationController pushViewController:controller animated:YES];
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
  
  AttendanceRecord *attendanceRecord = [self attendanceRecordAtIndexPath:indexPath];
  cell.textLabel.text = [NSString stringWithFormat:@"%@", attendanceRecord];
  
  return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.delegate respondsToSelector:@selector(attendanceHistoryViewController:didSelectAttendanceRecord:)]) {
    [self.delegate attendanceHistoryViewController:self didSelectAttendanceRecord:[self attendanceRecordAtIndexPath:indexPath]];
  }
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
    NSMutableArray *newRecords = [NSMutableArray arrayWithArray:self.records];
    [newRecords addObject:record];
    self.records = newRecords;
  }
}

@end
