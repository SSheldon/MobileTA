//
//  TAStudentTableViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 1/30/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsViewController.h"

#import "Student.h"
#import "StudentAttendance.h"

@implementation TAStudentsViewController

-(id)initWithStudents:(NSArray *)students {
  self = [self initWithStyle:UITableViewStylePlain];
  if (self) {
    self.students = students;
  }
  return self;
}

- (void)setStudents:(NSArray *)students {
  _students = [students copy];
  [self reloadStudents];
}

- (void)reloadStudents {
  _tableSections = [[NSMutableArray alloc] init];
  UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];

  // Add an empty student array for each section
  for (NSUInteger i = 0; i < collation.sectionTitles.count; i++) {
    [_tableSections addObject:[NSMutableArray array]];
  }

  // Add students to the array in the section determined by their last name
  for (Student *student in self.students) {
    NSInteger sectionNumber = [collation sectionForObject:student collationStringSelector:@selector(lastName)];
    [[_tableSections objectAtIndex:sectionNumber] addObject:student];
  }

  // Sort student array within each section
  NSArray *sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
  ];
  for (NSMutableArray *students in _tableSections) {
    // Sort using descriptors so that we can break ties with first name, which isn't possible with
    // UILocalizedIndexedCollation's sortedArrayFromArray:collationStringSelector:
    [students sortUsingDescriptors:sortDescriptors];
  }

  if ([self isViewLoaded]) {
    [self.tableView reloadData];
  }
}

- (void)reloadStudent:(Student *)student {
  NSIndexPath *path = [self indexPathOfStudent:student];
  if (path) {
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
  }
}

- (void)addStudent:(Student *)student {
  if (detailedStudentIndex) {
    Student *detailedStudent = [self studentAtIndexPath:detailedStudentIndex];
    self.students = [self.students arrayByAddingObject:student];
    detailedStudentIndex = [self indexPathOfStudent:detailedStudent];
  }
  else {
    self.students = [self.students arrayByAddingObject:student];
  }
}

- (void)removeStudent:(Student *)student {
  // Remove student from the Students array
  NSMutableArray *mutableStudents = [[self students] mutableCopy];
  [mutableStudents removeObject:student];
  _students = [mutableStudents copy];
}

- (Student *)studentAtIndexPath:(NSIndexPath *)indexPath {
  // If there are no student details or if the student details are in a different section,
  // we just proceed normally
  if (detailedStudentIndex == nil || [indexPath section] != [detailedStudentIndex section]) {
    return [[_tableSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  }
  // Otherwise, we need to adjust for the fact that the detail cell is there. To do that,
  // we just check whether the index is above the detailed student index.
  NSInteger adjustedIndex = [indexPath row];
  if ([detailedStudentIndex row] < [indexPath row]) {
    adjustedIndex--;
  }
  return [[_tableSections objectAtIndex:indexPath.section] objectAtIndex:adjustedIndex];
}

- (NSIndexPath *)indexPathOfStudent:(Student *)student {
  if ([[self students] indexOfObject:student] == NSNotFound) {
    return nil;
  }
  NSInteger studentSection = [[UILocalizedIndexedCollation currentCollation] sectionForObject:student collationStringSelector:@selector(lastName)];
  return [NSIndexPath indexPathForRow:[[_tableSections objectAtIndex:studentSection] indexOfObject:student] inSection:studentSection];
}

- (void)selectStudent:(Student *)student { }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Support all orientations
  return YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _tableSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger adjustment = 0;
  if (detailedStudentIndex != nil && [detailedStudentIndex section] == section) {
    adjustment++;
  }
  return [[_tableSections objectAtIndex:section] count] + adjustment;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  // Ensure this header isn't shown if we have no rows in the section
  if (![[_tableSections objectAtIndex:section] count]) {
    return nil;
  }
  return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  Student *student = [self studentAtIndexPath:indexPath];
  if([indexPath isEqual:[self indexPathOfDetailCell]]) {
    return [self createDetailCellForStudent:student];
  }
  
  return [self createDisplayCellForStudent:student];
}

- (UITableViewCell *)createDisplayCellForStudent:(Student *)student {
  static NSString *studentCellId = @"StudentCell";
  UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:studentCellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentCellId];
  }
  cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
  cell.backgroundColor = [UIColor greenColor];
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if(editingStyle == UITableViewCellEditingStyleDelete) {
    // If we are removing the student we are detailing, remove the cell
    if ([detailedStudentIndex isEqual:indexPath]) {
      [self hideStudentDetails];
    }
    // If we are removing something under the detailedStudentIndex, shift the
    // index down by 1
    if (indexPath.section == detailedStudentIndex.section && detailedStudentIndex.row > indexPath.row) {
      detailedStudentIndex = [NSIndexPath indexPathForRow:detailedStudentIndex.row-1 inSection:detailedStudentIndex.section];
      [[self tableView] scrollToRowAtIndexPath:[self indexPathOfDetailCell] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    Student *student = [self studentAtIndexPath:indexPath];
    // Remove student from the Students array
    [self removeStudent:student];
    // Remove the corresponding row from the table
    [[_tableSections objectAtIndex:indexPath.section] removeObject:student];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
  }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self selectStudent:[self studentAtIndexPath:indexPath]];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Student Details Methods

- (NSIndexPath *)indexPathOfDetailCell {
  // The detail cell should be the cell below the detailed student
  if (!detailedStudentIndex) {
    return nil;
  }
  return [NSIndexPath indexPathForRow:[detailedStudentIndex row]+1 inSection:[detailedStudentIndex section]];
}

- (UITableViewCell *)createDetailCellForStudent:(Student *)student {
  // By default, we have no idea what they want to show in the detail cell, but
  // it needs to return SOMETHING, so just make another display cell for the
  // the same student
  return [self createDisplayCellForStudent:student];
}

- (void)showDetailsForStudent:(Student *)student {
  NSIndexPath *oldIndex = detailedStudentIndex;
  [self hideStudentDetails];
  NSIndexPath *newIndex = [self indexPathOfStudent:student];
  if (![oldIndex isEqual:newIndex]) {
    detailedStudentIndex = newIndex;
    NSIndexPath *detailCellIndexPath = [self indexPathOfDetailCell];
    [[self tableView] insertRowsAtIndexPaths:@[detailCellIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [[self tableView] scrollToRowAtIndexPath:detailCellIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
  }
}

- (void)hideStudentDetails {
  // If the detail view isn't on,
  if (!detailedStudentIndex) {
    return;
  }
  NSIndexPath *cache = [self indexPathOfDetailCell];
  detailedStudentIndex = nil;
  [[self tableView] deleteRowsAtIndexPaths:@[cache] withRowAnimation:UITableViewRowAnimationBottom];
}

@end