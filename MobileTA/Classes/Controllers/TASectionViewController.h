//
//  TASectionViewController.h
//  MobileTA
//
//  Created by Steven Sheldon on 3/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatingChartViewController.h"
#import "TAStudentsAttendanceViewController.h"
#import "TAStudentEditViewController.h"
#import "TAAttendanceHistoryViewController.h"

@class TAStudentDetailCell;
@class TAStudentDisplayCell;

@interface TASectionViewController : TASeatingChartViewController <TAStudentsAttendanceDelegate, TAStudentEditDelegate, TAAttendanceHistoryDelegate>

@end
