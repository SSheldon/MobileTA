//
//  TAStudentDetailCell.h
//  MobileTA
//
//  Created by Scott on 3/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TASectionViewController.h"

@class TASectionViewController;

@interface TAStudentDetailCell : UITableViewCell {
  UIButton *plusParticipation;
  UIButton *minusParticipation;
  UIButton *absent;
  UIButton *tardy;
}

@property (nonatomic,weak)TASectionViewController *controller;

@end
