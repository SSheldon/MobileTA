//
//  TAAttendanceHistoryViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAAttendanceHistoryViewController.h"

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
  }
  return self;
}

- (id)initWithSection:(Section *)section {
  self = [super init];
  if (self) {
    self.section = section;
    self.records = [NSMutableArray arrayWithArray:[section.attendanceRecords allObjects]];
  }
  return self;
}

- (void)setRecords:(NSArray *)records {
  _records = [records copy];
  if ([self isViewLoaded]) {
    [self.tableView reloadData];
  }
}

- (AttendanceRecord *)attendanceRecordAtIndexPath:(NSIndexPath *)indexPath {
  return [[self records] objectAtIndex:[indexPath row]];
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

@end
