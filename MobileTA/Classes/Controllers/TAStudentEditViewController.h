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
#import "Section.h"

@class TAStudentEditViewController;
@class Section;

@protocol TAStudentEditDelegate <NSObject>

@optional
- (void)viewController:(TAStudentEditViewController *)viewController savedStudent:(Student *)student withPreviousData:(NSDictionary *)oldData;

@end

@interface TAStudentEditViewController : QuickDialogController {
  NSArray *_groups;
}

+ (QRootElement *)formForStudent:(Student *)student withGroupOptions:(NSArray *)groups;
- (id)initWithStudent:(Student *)student inSection:(Section *)section;

@property(nonatomic,strong)Student *student;
@property(nonatomic,strong)Section *section;
@property(nonatomic,weak)id<TAStudentEditDelegate> delegate;

@end