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

@interface TAAttendanceHistoryViewController : UITableViewController

- (id)initWithSection:(Section *) section;

@property (copy, nonatomic) NSArray *records;
@property (retain, nonatomic) Section *section;
@end