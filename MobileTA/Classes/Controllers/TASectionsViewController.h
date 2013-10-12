//
//  TASectionsViewController.h
//  MobileTA
//
//  Created by Scott on 2/25/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAFetchedResultsTableViewController.h"
#import "TASectionEditViewController.h"

@interface TASectionsViewController : TAFetchedResultsTableViewController <TASectionEditDelegate>

- (void)addSectionWithStudents:(NSArray *)students;

@end
