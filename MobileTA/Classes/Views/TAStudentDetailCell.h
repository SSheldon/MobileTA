//
//  TAStudentDetailCell.h
//  MobileTA
//
//  Created by Scott on 3/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "StudentAttendance.h"

@class TAStudentDetailCell;

@protocol TAStudentDetailDelegate <NSObject>
- (void)studentDetailCellDidMarkAbsent:(TAStudentDetailCell *)cell;
- (void)studentDetailCellDidMarkTardy:(TAStudentDetailCell *)cell;
- (void)studentDetailCellDidAddParticipation:(TAStudentDetailCell *)cell;
- (void)studentDetailCellDidSubtractParticipation:(TAStudentDetailCell *)cell;
- (void)studentDetailCellDidSendEmail:(TAStudentDetailCell *)cell;
@end

@interface TAStudentDetailCell : UITableViewCell

@property (weak, nonatomic) id<TAStudentDetailDelegate> delegate;
@property (readonly, nonatomic) UIButton *emailButton;

- (void)setStatus:(StudentAttendanceStatus)status;
- (void)setParticipation:(int16_t)participation;

@end
