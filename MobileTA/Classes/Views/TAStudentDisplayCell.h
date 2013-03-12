//
//  TAStudentDisplayCell.h
//  MobileTA
//
//  Created by Yuwei Chen on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TASectionViewController.h"
#import "StudentAttendance.h"

@class TASectionViewController;

@interface TAStudentDisplayCell : UITableViewCell {
  
}

@property(nonatomic,strong)UIView *statusView;
@property(nonatomic,strong)UILabel *participationLabel;
@property (nonatomic,weak)TASectionViewController *controller;

- (void)setStatus: (NSInteger)status;
- (void)setParticipation: (NSInteger)participation;

@end
