//
//  TAStudentsGroupsViewController.h
//  MobileTA
//
//  Created by Steven Sheldon on 4/26/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAFetchedResultsTableViewController.h"

@class Section;
@protocol TAStudentsAttendanceDelegate;

@interface TAStudentsGroupsViewController : TAFetchedResultsTableViewController

@property (strong, nonatomic) Section *section;
@property (weak, nonatomic) id<TAStudentsAttendanceDelegate> delegate;

@end
