//
//  TAStudentTableViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 1/30/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsViewController.h"

#import "Student.h"

@implementation TAStudentsViewController {
  NSMutableArray *_tableSections;
}

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
  for (NSInteger i = 0; i < collation.sectionTitles.count; i++) {
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

- (Student *)studentAtIndexPath:(NSIndexPath *)indexPath {
  return [[_tableSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
  return [[_tableSections objectAtIndex:section] count];
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
  if([indexPath row] == indexOfDetailedStudent + 1) {
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
  
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if(editingStyle == UITableViewCellEditingStyleDelete) {
    // Remove the student at that index from the database
    Student *student = [self studentAtIndexPath:indexPath];
    [[self managedObjectContext] deleteObject:student];
    // TODO(ssheldon)
    // jk TODO(srice): Handle Errors
    [[self managedObjectContext] save:nil];
    // Remove student from the Students array
    NSMutableArray *mutableStudents = [[self students] mutableCopy];
    [mutableStudents removeObject:student];
    [self setStudents:[NSArray arrayWithArray:mutableStudents]];
    [self reloadStudents];
  }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self selectStudent:[self studentAtIndexPath:indexPath]];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Student Details Methods

- (UITableViewCell *)createDetailCellForStudent:(Student *)student {
  // For now, just make the same cell again
  return [self createDisplayCellForStudent:student];
}

- (void)showDetailsForStudent:(Student *)student {
  
}

- (void)hideStudentDetails {
    
}

@end
