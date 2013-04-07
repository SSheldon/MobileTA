//
//  TASectionViewController.h
//  MobileTA
//
//  Created by Steven Sheldon on 3/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsAttendanceViewController.h"
#import "TAStudentEditViewController.h"
#import "TAAttendanceHistoryViewController.h"

@class TAStudentDetailCell;
@class TAStudentDisplayCell;

@interface TASectionViewController : TAStudentsAttendanceViewController <TAStudentEditDelegate, TAAttendanceHistoryDelegate>

- (id)initWithSection:(Section *)section;

@property (strong, nonatomic) Section *section;
@property (strong, nonatomic) AttendanceRecord *attendanceRecord;

@end
