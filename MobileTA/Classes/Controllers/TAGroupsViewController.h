//
//  TAGroupsViewController.h
//  MobileTA
//
//  Created by Scott on 4/22/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"
#import <MessageUI/MessageUI.h>
#import "TAGroupsEditViewController.h"
#import "QuickDialogController.h"
#import <QuickDialog/QuickDialog.h>

@class Section;

@class TAGroupsViewController;

@protocol TAGroupsViewControllerDelegate <NSObject>

- (void)groupsViewControllerDidCancel:(TAGroupsViewController *)groupsViewController;

@optional
- (void)groupsViewController:(TAGroupsViewController *)controller didUpdateGroup:(Group *)group;
- (void)groupsViewController:(TAGroupsViewController *)controller didRemoveGroup:(Group *)group;

@end

@interface TAGroupsViewController : UITableViewController <TAGroupEditDelegate,MFMailComposeViewControllerDelegate>

- (id)initWithSection:(Section *)section;

@property(nonatomic,readonly)NSArray *groups;
@property(nonatomic,readonly)Section *section;
@property(nonatomic,weak)id<TAGroupsViewControllerDelegate> delegate;

@end
