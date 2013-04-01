//
//  TASeatingChartView.h
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TASeatView.h"

@class TASeatingChartView;

@protocol TASeatingChartViewDelegate <NSObject>

@optional
- (void)didSelectSeat:(Seat *)seat;
- (void)didDeleteSeat:(Seat *)seat;
- (void)didMoveSeat:(Seat *)seat toLocation:(CGPoint)location;

@end

@interface TASeatingChartView : UIView <UIGestureRecognizerDelegate, TASeatViewDelegate> {
  NSMutableArray *_seatViews;
}

+ (CGSize)roomPixelSize;

- (id)initWithDefaultFrame;

- (void)addSeat:(Seat *)seat;

- (id)lastSeat;

@property(nonatomic,getter = isEditing)BOOL editing;
@property(nonatomic,weak)id<TASeatingChartViewDelegate> delegate;

@end
