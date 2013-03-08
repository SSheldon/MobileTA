//
//  TASectionEditViewController.h
//  MobileTA
//
//  Created by Ted Kalaw on 3/6/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickDialog/QuickDialog.h>
#import "Section.h"

@class TASectionEditViewController;

@protocol TASectionEditDelegate <NSObject>

@optional
- (void)viewController:(TASectionEditViewController *)viewController savedSection:(Section *)section withPreviousData:(NSDictionary *)oldData;

@end

@interface TASectionEditViewController : QuickDialogController {
}

+ (QRootElement *)formForSection:(Section*)section;
- (id)initWithSection:(Section*)section;

@property(nonatomic,strong)Section *section;
@property(nonatomic,weak)id<TASectionEditDelegate> delegate;

@end
