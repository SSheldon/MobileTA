//
//  TASectionViewController.h
//  MobileTA
//
//  Created by Steven Sheldon on 3/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatingChartViewController.h"
#import "TAStudentEditViewController.h"
#import "TAAttendanceHistoryViewController.h"
#import <MessageUI/MessageUI.h>

@interface TASectionViewController : TASeatingChartViewController <TAStudentEditDelegate, TAAttendanceHistoryDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

@end
