//
//  TAStudentEditViewController.h
//  MobileTA
//
//  Created by Scott on 2/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickDialog/QuickDialog.h>
#import "Student.h"

@class TAStudentEditViewController;

@protocol TAStudentEditDelegate <NSObject>

@optional
- (void)viewController:(TAStudentEditViewController *)viewController savedStudent:(Student *)student withPreviousData:(NSDictionary *)oldData;

@end

@interface TAStudentEditViewController : QuickDialogController {

}

+ (QRootElement *)formForStudent:(Student *)student;
- (id)initWithStudent:(Student *)student;

@property(nonatomic,strong)Student *student;
@property(nonatomic,weak)id<TAStudentEditDelegate> delegate;

@end