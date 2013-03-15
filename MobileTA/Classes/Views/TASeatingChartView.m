//
//  TASeatingChartView.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatingChartView.h"

@implementation TASeatingChartView

@synthesize delegate=_delegate;
@synthesize editing=_editing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      // Initialization code
      _seatViews = [NSMutableArray arrayWithCapacity:30];
    }
    return self;
}

- (void)addSeat:(Seat *)seat {
  // Make a seat view at 0,0.
  TASeatView *seatView = [[TASeatView alloc] initWithFrame:CGRectMake([seat.x intValue] * UNIT_PIXEL_RATIO, [seat.y intValue] * UNIT_PIXEL_RATIO, 0, 0)];
  [_seatViews addObject:seatView];
  [self addSubview:seatView];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  [self drawGrid];
}

- (void)drawGrid {
  for (NSUInteger x = 0 ; x < ROOM_WIDTH_UNITS ; x++) {
    [self drawLineFromPoint:CGPointMake(x * UNIT_PIXEL_RATIO, 0) toPoint:CGPointMake(x * UNIT_PIXEL_RATIO, ROOM_HEIGHT_UNITS * UNIT_PIXEL_RATIO) bolded:!(x % GRID_BOLD_SPACING_UNITS)];
  }
  for (NSUInteger y = 0 ; y < ROOM_HEIGHT_UNITS ; y++) {
    [self drawLineFromPoint:CGPointMake(0, y * UNIT_PIXEL_RATIO) toPoint:CGPointMake(ROOM_WIDTH_UNITS * UNIT_PIXEL_RATIO, y * UNIT_PIXEL_RATIO) bolded:!(y % GRID_BOLD_SPACING_UNITS)];
  }
}

- (void)drawLineFromPoint:(CGPoint)start toPoint:(CGPoint)end bolded:(BOOL)bold {
  CGFloat lineWidth = 1.0;
  UIColor *lineColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:(bold ? 0.6 : 0.2)];
  [lineColor set];
  /* Get the current graphics context */
  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  /* Set the width for the line */
  CGContextSetLineWidth(currentContext,lineWidth);
  /* Start the line at this point */
  CGContextMoveToPoint(currentContext,start.x, start.y);
  /* And end it at this point */
  CGContextAddLineToPoint(currentContext,end.x, end.y);
  /* Use the context's current color to draw the line */
  CGContextStrokePath(currentContext);
}

@end
