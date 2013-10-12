//
//  TAFetchedResultsTableViewController.h
//  MobileTA
//
//  Created by Steven Sheldon on 10/12/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

@interface TAFetchedResultsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (readonly, nonatomic) NSFetchedResultsController *fetchedResultsController;

//! The fetch request used to get the objects.
@property (readonly, nonatomic) NSFetchRequest *fetchRequest;

//! A key path on result objects that returns the section name.
@property (readonly, nonatomic) NSString *sectionNameKeyPath;

//! The name of the cache file the receiver should use.
@property (readonly, nonatomic) NSString *cacheName;

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
