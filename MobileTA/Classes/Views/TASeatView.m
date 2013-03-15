//
//  TASeatView.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatView.h"


@implementation TASeatView

- (id)initWithFrame:(CGRect)frame
{
  frame = CGRectMake(frame.origin.x,frame.origin.y,SEAT_WIDTH_UNITS * UNIT_PIXEL_RATIO, SEAT_HEIGHT_UNITS * UNIT_PIXEL_RATIO);
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setBackgroundColor:[UIColor redColor]];
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
