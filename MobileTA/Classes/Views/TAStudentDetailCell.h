//
//  TAStudentDetailCell.h
//  MobileTA
//
//  Created by Scott on 3/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TAStudentDetailCell;

@protocol TAStudentDetailDelegate <NSObject>
- (void)studentDetailCellDidMarkAbsent:(TAStudentDetailCell *)cell;
- (void)studentDetailCellDidMarkTardy:(TAStudentDetailCell *)cell;
- (void)studentDetailCellDidAddParticipation:(TAStudentDetailCell *)cell;
- (void)studentDetailCellDidSubtractParticipation:(TAStudentDetailCell *)cell;
- (BOOL)cellCanSendEmail:(TAStudentDetailCell *)cell;
- (void)studentDetailCellDidSendEmail:(TAStudentDetailCell *)cell;
@end

@interface TAStudentDetailCell : UITableViewCell {
  UIButton *plusParticipation;
  UIButton *minusParticipation;
  UIButton *absent;
  UIButton *tardy;
  UIButton *email;
}

@property (nonatomic,weak) id<TAStudentDetailDelegate> delegate;

@end
