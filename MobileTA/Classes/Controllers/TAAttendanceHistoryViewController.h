//
//  TAAttendanceHistoryViewController.h
//  MobileTA
//
//  Created by Ted Kalaw on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendanceRecord.h"
#import "Section.h"

@class TAAttendanceHistoryViewController;

@protocol TAAttendanceHistoryDelegate <NSObject>
@optional
- (void)attendanceHistoryViewController:(TAAttendanceHistoryViewController *)controller
              didSelectAttendanceRecord:(AttendanceRecord *)record;
- (void)attendanceHistoryViewControllerDidCancel:(TAAttendanceHistoryViewController *)controller;
@end

@interface TAAttendanceHistoryViewController : UITableViewController

- (id)initWithSection:(Section *) section;

@property (copy, nonatomic) NSArray *records;
@property (retain, nonatomic) Section *section;
@property (weak, nonatomic) id<TAAttendanceHistoryDelegate> delegate;

@end