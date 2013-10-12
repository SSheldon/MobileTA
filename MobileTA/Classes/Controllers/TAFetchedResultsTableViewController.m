//
//  TAFetchedResultsTableViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 10/12/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAFetchedResultsTableViewController.h"

@interface TAFetchedResultsTableViewController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation TAFetchedResultsTableViewController

- (NSFetchRequest *)fetchRequest {
  return nil;
}

- (NSString *)sectionNameKeyPath {
  return nil;
}

- (NSString *)cacheName {
  return nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.fetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:self.sectionNameKeyPath
                                                   cacheName:self.cacheName];
  self.fetchedResultsController.delegate = self;

  NSError *error = nil;
  BOOL successful = [self.fetchedResultsController performFetch:&error];
  NSAssert(successful, @"Fetch failed with error %@", error);
}

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath {
  id obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [self.managedObjectContext deleteObject:obj];
  [self saveManagedObjectContext];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> info = self.fetchedResultsController.sections[section];
  return info.numberOfObjects;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> info = self.fetchedResultsController.sections[section];
  return info.name;
}

-  (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self deleteObjectAtIndexPath:indexPath];
  }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
    case NSFetchedResultsChangeUpdate:
      [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
    case NSFetchedResultsChangeMove:
      [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
}

@end
