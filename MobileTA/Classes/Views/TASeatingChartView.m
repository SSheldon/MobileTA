//
//  TASeatingChartView.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatingChartView.h"

#import "Seat.h"
#import "TAGridConstants.h"

BOOL TARectIntersectsRect(CGRect rect1, CGRect rect2) {
  if (CGRectIntersectsRect(rect1, rect2)) {
    CGRect intersection = CGRectIntersection(rect1, rect2);
    if (intersection.size.width < u2p(1) || intersection.size.height < u2p(1)) {
      return NO;
    }
    else {
      return YES;
    }
  }
  return NO;
}

@interface TASeatingChartView (PrivateMethods)

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
  UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
  [tap setDelegate:self];
  [self addGestureRecognizer:tap];
  return self;
}

- (void)addSeat:(Seat *)seat {
  // Make a seat view at 0,0.
  TASeatView *seatView = [[TASeatView alloc] initWithSeat:seat];
  if (![self canMoveSeat:seatView toPoint:[seatView frame].origin]) {
    [self addSubview:seatView];
    [self removeSeatView:seatView];
    return;
  }
  [_seatViews addObject:seatView];
  // Add gesture recognizers
  UIGestureRecognizer *move = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
  [move setDelegate:self];
  [seatView addGestureRecognizer:move];
  [self addSubview:seatView];
  // If we add a seat while we are editing, make it dance
  [seatView setEditing:_editing];
  [seatView setDelegate:self];
}

- (id)lastSeat {
  TASeatView *seatView = [_seatViews lastObject];
  if (!seatView) {
    return nil;
  }
  return seatView.seat;
}

- (void)removeSeatView:(TASeatView *)seatView {
  // If the seatView is dancing, stop it
  if (_editing) {
    [seatView stopDancing];
  }
  [UIView animateWithDuration:.5 animations:^{
    [seatView setAlpha:0.0];
    [seatView setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
  } completion:^(BOOL finished){
    [seatView removeFromSuperview];
    [_seatViews removeObject:seatView];
  }];
}

- (void)setEditing:(BOOL)editing {
  // If we change state
  if (_editing != editing) {
    _editing = editing;
    for (NSUInteger i = 0; i < [_seatViews count]; i++) {
      [[_seatViews objectAtIndex:i] setEditing:_editing];
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

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer {
  NSManagedObjectContext *managedObjectContext = [(TAAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  CGPoint tapLocation = [gestureRecognizer locationInView:self];
  CGPoint extraGridTranslation = CGPointMake(fmodf(tapLocation.x - (SEAT_WIDTH_UNITS * UNIT_PIXEL_RATIO/ 4),UNIT_PIXEL_RATIO), fmodf(tapLocation.y - (SEAT_HEIGHT_UNITS * UNIT_PIXEL_RATIO/ 4),UNIT_PIXEL_RATIO));
  CGPoint newSeatLocation = CGPointMake(tapLocation.x - (SEAT_WIDTH_UNITS * UNIT_PIXEL_RATIO/4) - extraGridTranslation.x,tapLocation.y - (SEAT_HEIGHT_UNITS * UNIT_PIXEL_RATIO/4) - extraGridTranslation.y);
  Seat *seat = [NSEntityDescription insertNewObjectForEntityForName:@"Seat" inManagedObjectContext:managedObjectContext];
  seat.x = p2u(newSeatLocation.x);
  seat.y = p2u(newSeatLocation.y);
  [self addSeat: seat];
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
      if ([_delegate respondsToSelector:@selector(didMoveSeat:toLocation:)]) {
        [_delegate didMoveSeat:seatView.seat toLocation:unitLocation];
      }
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
      if (TARectIntersectsRect(newFrame,[current frame])) {
        return NO;
      }
    }
  }
  return YES;
}

- (TASeatView *)seatViewForSeat:(Seat *)seat {
  for (NSUInteger i = 0; i < [_seatViews count]; i++) {
    TASeatView *current = [_seatViews objectAtIndex:i];
    if ([current seat] == seat) {
      return current;
    }
  }
  return nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  for (UIView *subview in self.subviews) {
    // Check for the delete buttons first, as they are a special case
    if ([self isEditing] && [subview isKindOfClass:[TASeatView class]]) {
      TASeatView *seatView = (TASeatView *)subview;
      CGPoint pointInSeatViewCoordinates = [seatView convertPoint:point fromView:self];
      if (CGRectContainsPoint([[seatView deleteButton] frame], pointInSeatViewCoordinates)) {
        return [seatView deleteButton];
      }
    }
    if (CGRectContainsPoint(subview.frame, point)) {
      return subview;
    }
  }
  return [super hitTest:point withEvent:event];
}

# pragma mark TASeatViewDelegate

- (void)deleteSeatView:(TASeatView *)seatView {
  [self removeSeatView:seatView];
  if ([_delegate respondsToSelector:@selector(didDeleteSeat:)]) {
    [_delegate didDeleteSeat:[seatView seat]];
  }
}

# pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
    return [self isEditing];
  }
  if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
    // Don't do a tap gesture unless the view is editing
    if (![self isEditing]) {
      return NO;
    }
    // We don't want the gesture recognizer to fire if the user is trying to
    // press the delete button of a seat
    for (NSUInteger i = 0; i < [_seatViews count]; i++) {
      TASeatView *current = [_seatViews objectAtIndex:i];
      if (CGRectContainsPoint([[current deleteButton] frame], [gestureRecognizer locationInView:current])) {
        return NO;
      }
    }
    return YES;
  }
  // By default, we want to listen to the UIGestureRecognizer
  return YES;
}

@end
