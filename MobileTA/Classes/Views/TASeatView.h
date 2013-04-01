//
//  TASeatView.h
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Seat.h"
#import "TAGridConstants.h"

@class TASeatView;

@protocol TASeatViewDelegate <NSObject>

@optional
// Please kill me
- (void)deleteSeatView:(TASeatView *)seatView;

@end

@interface TASeatView : UIView {
  UIImageView *_backgroundView;
}

- (id)initWithSeat:(Seat *)seat;

- (void)moveToGridLocation:(CGPoint)unitPoint;

// YEAH! PARTY
- (void)dance;
// Cops showed up. Party is over.
- (void)stopDancing;

@property(nonatomic,weak)id<TASeatViewDelegate> delegate;

@property(nonatomic,strong)Seat *seat;
@property(nonatomic,getter = isEditing)BOOL editing;
@property(nonatomic,readonly)UIButton *deleteButton;
@property(nonatomic,getter = isInvalidLocation)BOOL invalidLocation;

@end
