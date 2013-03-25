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

+ (CGSize)roomPixelSize {
  return CGSizeMake(u2p(ROOM_WIDTH_UNITS),u2p(ROOM_HEIGHT_UNITS));
}

- (id)initWithDefaultFrame {
  self = [self initWithFrame:CGRectMake(0, 0, u2p(ROOM_WIDTH_UNITS), u2p(ROOM_HEIGHT_UNITS))];
  if (self) {
    
  }
  return self;
}

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
  TASeatView *seatView = [[TASeatView alloc] initWithSeat:seat];
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
  // When we start moving a seat, it should stop dancing.
  if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
    [seatView stopDancing];
  }
  CGPoint translation = [gestureRecognizer translationInView:self];
  CGPoint currentLocation = [seatView frame].origin;
  // This is what implements snapping to grid. extraGridTranslation is the CGPoint
  // representing any extra translation after the closest grid line. By subtracting
  // this value from currentLocation + translation, we can make sure newLocation
  // is on a grid line.
  CGPoint extraGridTranslation = CGPointMake(fmodf(translation.x,UNIT_PIXEL_RATIO), fmodf(translation.y,UNIT_PIXEL_RATIO));
  CGPoint newLocation = CGPointMake(currentLocation.x + translation.x - extraGridTranslation.x, currentLocation.y + translation.y - extraGridTranslation.y);
  // Check that the new location is within the bounds of the Seating Chart
  newLocation.x = MAX(newLocation.x,0);
  newLocation.x = MIN(newLocation.x,u2p(ROOM_WIDTH_UNITS - SEAT_WIDTH_UNITS));
  newLocation.y = MAX(newLocation.y,0);
  newLocation.y = MIN(newLocation.y,u2p(ROOM_HEIGHT_UNITS - SEAT_HEIGHT_UNITS));
  // Move the seatView to the new location
  CGPoint unitLocation = CGPointMake(p2u(newLocation.x), p2u(newLocation.y));
  [seatView moveToGridLocation:unitLocation];
//  [seatView setFrame:CGRectMake(newLocation.x, newLocation.y, [seatView bounds].size.width, [seatView bounds].size.height)];
  [gestureRecognizer setTranslation:extraGridTranslation inView:self];
  [seatView setInvalidLocation:![self canMoveSeat:seatView toPoint:newLocation]];
  if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
    // If they try to drop it in an invalid location, put the seat back to where
    // it was. Otherwise, move the seat to the correct location and notify the
    // controller
    if ([seatView isInvalidLocation]) {
      [seatView moveToGridLocation:[seatView.seat location]];
      // The old location was definitely valid. Otherwise how would they have been there.
      [seatView setInvalidLocation:NO];
    }
    else {
      [[seatView seat] setLocation:unitLocation];
    }
    // When we are done with a seat, it should dance
    [seatView dance];
  }
}

- (BOOL)canMoveSeat:(TASeatView *)seat toPoint:(CGPoint)point {
  CGRect newFrame = CGRectMake(point.x, point.y, u2p(SEAT_WIDTH_UNITS), u2p(SEAT_HEIGHT_UNITS));
  for (NSUInteger i = 0; i < [_seatViews count]; i++) {
    TASeatView *current = [_seatViews objectAtIndex:i];
    // Clearly the seat intersects with itself, so ignore that
    if (current == seat) {
      continue;
    }
    else {
      if (CGRectIntersectsRect(newFrame,[current frame])) {
        return NO;
      }
    }
  }
  return YES;
}

- (void)startEditingAnimation {
  for (NSUInteger i = 0; i < [_seatViews count]; i++) {
    [[_seatViews objectAtIndex:i] dance];
  }
}

- (void)stopEditingAnimation {
  for (NSUInteger i = 0; i < [_seatViews count]; i++) {
    [[_seatViews objectAtIndex:i] stopDancing];
  }
}

@end
