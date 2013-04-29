//
//  TAStudentsGroupsViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/26/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsGroupsViewController.h"

#import "Group.h"

@implementation TAStudentsGroupsViewController

- (void)setGroups:(NSArray *)groups {
  _groups = groups;
  [self reloadStudents];
}

#pragma mark TAStudentsViewController

- (NSArray *)students {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (void)setStudents:(NSArray *)students {
  [self doesNotRecognizeSelector:_cmd];
}

- (void)reloadStudents {
  _tableSections = [[NSMutableArray alloc] init];

  // Add the sorted students for each section
  NSArray *sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
  ];
  for (Group *group in self.groups) {
    NSMutableArray *students = [NSMutableArray arrayWithArray:[group.students allObjects]];
    [students sortUsingDescriptors:sortDescriptors];
    [_tableSections addObject:students];
  }

  if ([self isViewLoaded]) {
    [self.tableView reloadData];
  }
}

- (void)removeStudent:(Student *)student {
  // We don't have a students array, so override this to not remove anything
  if ([self.delegate respondsToSelector:@selector(viewController:didRemoveStudent:)]) {
    [self.delegate viewController:self didRemoveStudent:student];
  }
}

- (NSIndexPath *)indexPathOfStudent:(Student *)student {
  NSInteger sectionIndex = [self.groups indexOfObject:student.group];
  if (sectionIndex == NSNotFound) {
    return nil;
  }
  NSInteger rowIndex = [[_tableSections objectAtIndex:sectionIndex] indexOfObject:student];
  if (rowIndex == NSNotFound) {
    return nil;
  }
  if (detailedStudentIndex && detailedStudentIndex.section == sectionIndex && detailedStudentIndex.row < rowIndex) {
    rowIndex++;
  }
  return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
}

#pragma mark UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [[self.groups objectAtIndex:section] name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  // Disable the index
  return nil;
}

@end
