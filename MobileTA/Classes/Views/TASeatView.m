//
//  TASeatView.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatView.h"


@implementation TASeatView

@synthesize seat=_seat;

+ (UIImage *)backgroundImage {
  static UIImage *__shared = nil;
  return (__shared) ? __shared : (__shared = [UIImage imageNamed:@"seat.png"]);
}

- (id)initWithFrame:(CGRect)frame
{
  frame = CGRectMake(frame.origin.x,frame.origin.y,u2p(SEAT_WIDTH_UNITS), u2p(SEAT_HEIGHT_UNITS));
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  // Drawing code
  [[TASeatView backgroundImage] drawInRect:[self bounds]];
}


@end
