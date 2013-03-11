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
#import "TAAttendanceRecordEditViewController.h"

@interface TASectionViewController : TAStudentsViewController <TAStudentEditDelegate,TAAttendanceRecordEditDelegate>

- (id)initWithSection:(Section *)section;

@property (strong, nonatomic) Section *section;
@property (strong, nonatomic) AttendanceRecord *attendanceRecord;

@end
