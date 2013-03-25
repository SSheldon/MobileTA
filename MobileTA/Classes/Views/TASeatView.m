//
//  TASeatView.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatView.h"


@interface TASeatView (PrivateMethods)

- (CGRect)frameForGridLocation:(CGPoint)unitPoint;

@end

@implementation TASeatView

@synthesize seat=_seat;
@synthesize invalidLocation=_invalidLocation;

+ (UIImage *)backgroundImage {
  static UIImage *__shared = nil;
  return (__shared) ? __shared : (__shared = [UIImage imageNamed:@"seat.png"]);
}

- (id)initWithSeat:(Seat *)seat {
  self = [self initWithFrame:[self frameForGridLocation:[seat location]]];
  if (self) {
    [self setSeat:seat];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

- (void)moveToGridLocation:(CGPoint)unitPoint {
  [self setFrame:[self frameForGridLocation:unitPoint]];
}

- (void)setInvalidLocation:(BOOL)invalidLocation {
  if (invalidLocation != _invalidLocation) {
    _invalidLocation = invalidLocation;
    [self setBackgroundColor: _invalidLocation ? [UIColor redColor] : [UIColor clearColor]];
  }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  // Drawing code
  [[TASeatView backgroundImage] drawInRect:[self bounds]];
}

#pragma mark Private Methods

- (CGRect)frameForGridLocation:(CGPoint)unitPoint {
  return CGRectMake(u2p(unitPoint.x), u2p(unitPoint.y), u2p(SEAT_WIDTH_UNITS), u2p(SEAT_HEIGHT_UNITS));
}


@end
