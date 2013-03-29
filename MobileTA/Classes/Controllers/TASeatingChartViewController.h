//
//  TASeatingChartViewController.h
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Seat.h"
#import "Section.h"
#import "TASeatingChartView.h"

@interface TASeatingChartViewController : UIViewController <UIScrollViewDelegate> {
  UIScrollView *_scrollView;
  UIBarButtonItem * addButtonItem;
}

- (id)initWithSection:(Section *)section;

@property(nonatomic,readonly)TASeatingChartView *seatingChart;

@end
