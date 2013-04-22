//
//  TAGroupsViewController.h
//  MobileTA
//
//  Created by Scott on 4/22/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class Section;

@class TAGroupsViewController;

@protocol TAGroupsViewControllerDelegate <NSObject>

- (void)groupsViewControllerDidCancel:(TAGroupsViewController *)groupsViewController;

@end

@interface TAGroupsViewController : UITableViewController <MFMailComposeViewControllerDelegate>

- (id)initWithSection:(Section *)section;

@property(nonatomic,readonly)NSArray *groups;
@property(nonatomic,readonly)Section *section;
@property(nonatomic,weak)id<TAGroupsViewControllerDelegate> delegate;

@end
