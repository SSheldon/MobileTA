//
//  TAStudentsGroupsViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/26/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsGroupsViewController.h"

#import "Group.h"
#import "TAManagedObjectChangeObserver.h"

@implementation TAStudentsGroupsViewController

- (void)_contextDidSave:(NSNotification *)notification {
  [TAManagedObjectChangeObserver performActions:@[
    [TAManagedObjectChangeAction actionForChange:TAManagedObjectChangeUpdate
                                          entity:[NSEntityDescription entityForName:@"Group" inManagedObjectContext:self.managedObjectContext]
                                       predicate:[NSPredicate predicateWithFormat:@"section = %@ AND students.@count > 0", self.section]
                                       withBlock:^(Group *group) {
      if (self.isViewLoaded) {
        // The fetched results controller won't reload when a section name changes,
        // so we must manually fetch again and reload the table if a section's name changes.
        NSInteger groupSection = [self.fetchedResultsController indexPathForObject:[group.students anyObject]].section;
        id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[groupSection];
        if (![sectionInfo.name isEqualToString:group.name]) {
          [self.fetchedResultsController performFetch:NULL];
          [self.tableView reloadData];
        }
      }
    }],
    [TAManagedObjectChangeAction actionForChange:TAManagedObjectChangeAll
                                          entity:[NSEntityDescription entityForName:@"StudentAttendance" inManagedObjectContext:self.managedObjectContext]
                                       predicate:[NSPredicate predicateWithFormat:@"attendanceRecord = %@ AND student.group != NIL", self.attendanceRecord]
                                       withBlock:^(StudentAttendance *attendance) {
      [self reloadStudent:attendance.student];
    }],
  ] forChangeNotification:notification];
}

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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  // Disable the index
  return nil;
}

@end
