//
//  TAStudentsGroupsViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/26/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsGroupsViewController.h"

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

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  // Disable the index
  return nil;
}

@end
