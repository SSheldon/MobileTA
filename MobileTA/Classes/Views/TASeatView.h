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

@interface TASeatView : UIView

- (id)initWithSeat:(Seat *)seat;

- (void)moveToGridLocation:(CGPoint)unitPoint;

// YEAH! PARTY
- (void)dance;
// Cops showed up. Party is over.
- (void)stopDancing;

@property(nonatomic,strong)Seat *seat;
@property(nonatomic,getter = isInvalidLocation)BOOL invalidLocation;

@end
