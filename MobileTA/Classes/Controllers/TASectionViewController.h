//
//  TASectionViewController.h
//  MobileTA
//
//  Created by Steven Sheldon on 3/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsViewController.h"
#import "TAStudentEditViewController.h"
#import "TAStudentDetailCell.h"
#import "TAStudentDisplayCell.h"
#import "TAAttendanceHistoryViewController.h"

@class TAStudentDetailCell;
@class TAStudentDisplayCell;

@interface TASectionViewController : TAStudentsViewController <TAStudentEditDelegate, TAAttendanceHistoryDelegate>

- (id)initWithSection:(Section *)section;

@property (strong, nonatomic) Section *section;
@property (strong, nonatomic) AttendanceRecord *attendanceRecord;

- (UITableViewCell *)createDisplayCellForStudent:(Student *)student;

// TODO(ssheldon): Extract these to a delegate
- (void)studentDetailCellDidMarkAbsent:(TAStudentDetailCell *)cell;
- (void)studentDetailCellDidMarkTardy:(TAStudentDetailCell *)cell;
- (void)studentDetailCellDidAddParticipation:(TAStudentDetailCell *)cell;
- (void)studentDetailCellDidSubtractParticipation:(TAStudentDetailCell *)cell;

@end
