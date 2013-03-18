//
//  TASeatingChartView.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatingChartView.h"

@interface TASeatingChartView (PrivateMethods)

- (void)startEditingAnimation;
- (void)stopEditingAnimation;

@end

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
  TASeatView *seatView = [[TASeatView alloc] initWithFrame:CGRectMake(u2p([seat.x intValue]), u2p([seat.y intValue]), 0, 0)];
  [_seatViews addObject:seatView];
  // Add gesture recognizers
  UIGestureRecognizer *move = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
  [seatView addGestureRecognizer:move];
  [self addSubview:seatView];
}

- (void)setEditing:(BOOL)editing {
  // If we change state
  if (_editing != editing) {
    _editing = editing;
    if (_editing) {
      [self startEditingAnimation];
    }
    else {
      [self stopEditingAnimation];
    }
  }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  [self drawGrid];
}

- (void)drawGrid {
  for (NSUInteger x = 0 ; x < ROOM_WIDTH_UNITS ; x++) {
    [self drawLineFromPoint:CGPointMake(u2p(x), 0) toPoint:CGPointMake(u2p(x), u2p(ROOM_HEIGHT_UNITS)) bolded:!(x % GRID_BOLD_SPACING_UNITS)];
  }
  for (NSUInteger y = 0 ; y < ROOM_HEIGHT_UNITS ; y++) {
    [self drawLineFromPoint:CGPointMake(0, u2p(y)) toPoint:CGPointMake(u2p(ROOM_WIDTH_UNITS), u2p(y)) bolded:!(y % GRID_BOLD_SPACING_UNITS)];
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

#pragma mark Private Methods

- (void)didTap {
  NSLog(@"Tap!");
}

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer {
  TASeatView *seatView = (TASeatView *)[gestureRecognizer view];
  CGPoint translation = [gestureRecognizer translationInView:self];
  CGPoint currentLocation = [seatView frame].origin;
  // This is what implements snapping to grid. extraGridTranslation is the CGPoint
  // representing any extra translation after the closest grid line. By subtracting
  // this value from currentLocation + translation, we can make sure newLocation
  // is on a grid line.
  CGPoint extraGridTranslation = CGPointMake(fmodf(translation.x,UNIT_PIXEL_RATIO), fmodf(translation.y,UNIT_PIXEL_RATIO));
  CGPoint newLocation = CGPointMake(currentLocation.x + translation.x - extraGridTranslation.x, currentLocation.y + translation.y - extraGridTranslation.y);
  // Move the seatView to the new location
  [seatView setFrame:CGRectMake(newLocation.x, newLocation.y, [seatView bounds].size.width, [seatView bounds].size.height)];
  [gestureRecognizer setTranslation:extraGridTranslation inView:self];
}

- (void)startEditingAnimation {
  NSLog(@"Starting Edit Animation");
}

- (void)stopEditingAnimation {
  NSLog(@"Stopping Edit Animation");
}

@end
