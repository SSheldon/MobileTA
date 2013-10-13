//
//  TAStudentsGroupsViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/26/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsGroupsViewController.h"

#import "Group.h"
#import "Student.h"
#import "TAStudentsAttendanceViewController.h"

@implementation TAStudentsGroupsViewController

#pragma mark TAFetchedResultsTableViewController

- (NSFetchRequest *)fetchRequest {
  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
  fetch.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
  fetch.predicate = [NSPredicate predicateWithFormat:@"group.section = %@", self.section];
  fetch.sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"group.name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
  ];
  return fetch;
}

- (NSString *)sectionNameKeyPath {
  return @"group.name";
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *studentCellId = @"StudentCell";
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:studentCellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentCellId];
  }
  Student *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = student.fullDisplayName;
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Student *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
  if (self.isEditing) {
    if ([self.delegate respondsToSelector:@selector(viewController:didSelectStudentToEdit:)]) {
      [self.delegate viewController:nil didSelectStudentToEdit:student];
    }
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
