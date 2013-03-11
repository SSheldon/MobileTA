//
//  TAAttendanceRecordEditViewController.h
//  MobileTA
//
//  Created by Scott on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickDialog/QuickDialog.h>
#import "AttendanceRecord.h"

@class TAAttendanceRecordEditViewController;

@protocol TAAttendanceRecordEditDelegate <NSObject>

@optional
- (void)viewController:(TAAttendanceRecordEditViewController *)viewController savedAttendanceRecord:(AttendanceRecord *)attendanceRecord withPreviousData:(NSDictionary *)oldData;

@end

@interface TAAttendanceRecordEditViewController : QuickDialogController

+ (QRootElement *)formForAttendanceRecord:(AttendanceRecord *)attendancRecord;
- (id)initWithAttendanceRecord:(AttendanceRecord *)attendanceRecord;

@property(nonatomic,strong)AttendanceRecord *attendanceRecord;
@property(nonatomic,weak)id<TAAttendanceRecordEditDelegate> delegate;

@end