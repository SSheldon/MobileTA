//
//  TASeatingChartViewController.h
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TASeatingChartView.h"
#import "TAAssignSeatsViewController.h"

@class Section;
@class AttendanceRecord;

@interface TASeatingChartViewController : UIViewController <UIScrollViewDelegate, TASeatingChartViewDelegate, TAAssignSeatsViewDelegate> {
  UIBarButtonItem * addButtonItem;
}

- (id)initWithSection:(Section *)section;

@property (nonatomic, strong) AttendanceRecord *attendanceRecord;
@property (nonatomic, strong) Section *section;
@property(nonatomic,readonly)TASeatingChartView *seatingChart;
@property (nonatomic, readonly) UIScrollView *scrollView;

@end
