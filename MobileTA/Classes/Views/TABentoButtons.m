//
//  TABentoButtonsView.m
//  MobileTA
//
//  Created by Scott on 4/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TABentoButtons.h"

#define DEFAULT_BENTO_DIMENSION 88

@implementation TABentoButtons

- (id)initWithOrientation:(TABentoButtonsOrientation)orientation {
  self = [self initWithFrame:CGRectMake(0, 0, DEFAULT_BENTO_DIMENSION, DEFAULT_BENTO_DIMENSION)];
  if (self) {
    // Initialize
    [self setOrientation:orientation];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    [_label setBackgroundColor:[UIColor clearColor]];
    [_label setTextAlignment:NSTextAlignmentCenter];
    _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_upButton setTitle:@"\u25b2" forState:UIControlStateNormal];
    [_upButton addTarget:self action:@selector(up) forControlEvents:UIControlEventTouchUpInside];
    _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downButton setTitle:@"\u25bc" forState:UIControlStateNormal];
    [_downButton addTarget:self action:@selector(down) forControlEvents:UIControlEventTouchUpInside];
    _buttons = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_label];
    [self addSubview:_buttons];
    [_buttons addSubview:_upButton];
    [_buttons addSubview:_downButton];
    // Set the default orientation
    [self setOrientation:TABentoButtonsOrientationLeftButtons];
    [self setBackgroundColor:[UIColor blackColor]];
    [self setBackgroundColor:[UIColor redColor]];
  }
  return self;
}

- (void)setOrientation:(TABentoButtonsOrientation)orientation {
  if (orientation == _orientation) {
    return;
  }
  _orientation = orientation;
  [self setNeedsLayout];
}

- (void)setValue:(NSInteger)value {
  if (_value == value) {
    return;
  }
  _value = value;
  [_label setText:[self textForValue:_value]];
}

- (void)layoutSubviews {
  UIView *lhs = nil;
  UIView *rhs = nil;
  if (_orientation == TABentoButtonsOrientationLeftButtons) {
    lhs = _buttons;
    rhs = _label;
  }
  else {
    lhs = _label;
    rhs = _buttons;
  }
  [lhs setFrame:[self frameForLeftHandSide]];
  [rhs setFrame:[self frameForRightHandSize]];
  
  // Set the buttons to be half the height of their containing frame
  CGRect f = [_buttons frame];
  CGFloat buttonHeight = f.size.height/2;
  [_upButton setFrame:CGRectMake(0, 0, f.size.width, buttonHeight)];
  [_downButton setFrame:CGRectMake(0, buttonHeight, f.size.width, buttonHeight)];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  [[self lineColor] set];
  UIBezierPath *outside = [UIBezierPath bezierPathWithRect:[self bounds]];
  [outside stroke];
  CGSize s = [self bounds].size;
  UIBezierPath *middle = [self lineFromPoint:CGPointMake(s.width/2, 0) toPoint:CGPointMake(s.width/2, s.height)];
  [middle stroke];
  CGFloat offset = 0;
  if (_orientation == TABentoButtonsOrientationRightButtons) {
    offset = s.width/2;
  }
  UIBezierPath *buttonMiddle = [self lineFromPoint:CGPointMake(offset, s.height/2) toPoint:CGPointMake(offset + s.width/2, s.height/2)];
  [buttonMiddle stroke];
}

#pragma mark Private Methods

- (void)updateDelegate:(NSInteger)change {
  if ([_delegate respondsToSelector:@selector(bentoButtons:didUpdateValue:by:)]) {
    [_delegate bentoButtons:self didUpdateValue:_value by:change];
  }
}

- (void)up {
  [self setValue:_value + 1];
  [self updateDelegate:1];
}

- (void)down {
  [self setValue:_value - 1];
  [self updateDelegate:-1];
}

- (UIBezierPath *)lineFromPoint:(CGPoint)start toPoint:(CGPoint)end {
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path moveToPoint:start];
  [path addLineToPoint:end];
  [path closePath];
  return path;
}

- (CGRect)halfWidthFrame {
  CGRect frame = [self frame];
  return CGRectMake(0, 0, frame.size.width/2, frame.size.height);
}

- (CGRect)frameForLeftHandSide {
  return [self halfWidthFrame];
}

- (CGRect)frameForRightHandSize {
  CGRect f = [self halfWidthFrame];
  f.origin = CGPointMake(f.size.width, 0);
  return f;
}

- (NSString *)textForValue:(NSInteger)value {
  if (value == 0) {
    return @"+0";
  }
  else {
    return NSStringFromStudentParticipation(value);
  }
}

@end
