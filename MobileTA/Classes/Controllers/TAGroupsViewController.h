//
//  TAGroupsViewController.h
//  MobileTA
//
//  Created by Scott on 4/22/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "TAFetchedResultsTableViewController.h"
#import "TAGroupsEditViewController.h"

@class Section;

@class TAGroupsViewController;

@protocol TAGroupsViewControllerDelegate <NSObject>

- (void)groupsViewControllerDidCancel:(TAGroupsViewController *)groupsViewController;

@optional
- (void)groupsViewController:(TAGroupsViewController *)controller didUpdateGroup:(Group *)group;
- (void)groupsViewController:(TAGroupsViewController *)controller didRemoveGroup:(Group *)group;

@end

@interface TAGroupsViewController : TAFetchedResultsTableViewController <TAGroupEditDelegate, MFMailComposeViewControllerDelegate>

- (id)initWithSection:(Section *)section;

@property (readonly, nonatomic) Section *section;
@property (weak, nonatomic) id<TAGroupsViewControllerDelegate> delegate;

@end
