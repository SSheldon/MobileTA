//
//  TAGroupsEditViewController.h
//  MobileTA
//
//  Created by Ted Kalaw on 4/25/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "QuickDialogController.h"
#import <QuickDialog/QuickDialog.h>
#import "Group.h"
@class TAGroupsEditViewController;

@protocol TAGroupEditDelegate <NSObject>

@optional
- (void)viewController:(TAGroupsEditViewController *)viewController savedGroup:(Group *)group withPreviousData:(NSDictionary *)oldData;

@end

@interface TAGroupsEditViewController : QuickDialogController

+ (QRootElement *)formForGroup:(Group *)group;
- (id)initWithGroup:(Group *)group;

@property(nonatomic,strong)Group *group;
@property(nonatomic,weak)id<TAGroupEditDelegate> delegate;

@end
