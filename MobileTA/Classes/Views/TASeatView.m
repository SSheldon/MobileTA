//
//  TASeatView.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatView.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kDanceAnimationRotateDeg 6.0
#define kDanceAnimationTranslateX 1.0
#define kDanceAnimationTranslateY 2.0

@interface TASeatView (PrivateMethods)

- (CGRect)frameForGridLocation:(CGPoint)unitPoint;

@end

@implementation TASeatView

@synthesize delegate=_delegate;

@synthesize seat=_seat;
@synthesize editing=_editing;
@synthesize deleteButton=_deleteButton;
@synthesize invalidLocation=_invalidLocation;

+ (UIImage *)backgroundImage {
  static UIImage *__shared = nil;
  return (__shared) ? __shared : (__shared = [UIImage imageNamed:@"seat.png"]);
}

+ (UIImage *)deleteButtonImage {
  static UIImage *__shared = nil;
  return (__shared) ? __shared : (__shared = [UIImage imageNamed:@"delete_button.png"]);
}

- (id)initWithSeat:(Seat *)seat {
  self = [self initWithFrame:[self frameForGridLocation:[seat location]]];
  if (self) {
    [self setSeat:seat];
    _backgroundView = [[UIImageView alloc] initWithFrame:[self bounds]];
    [_backgroundView setImage:[TASeatView backgroundImage]];
    [self addSubview:_backgroundView];
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setBackgroundImage:[TASeatView deleteButtonImage] forState:UIControlStateNormal];
//    [_deleteButton setTitle:@"X" forState:UIControlStateNormal];
    [_deleteButton setFrame:CGRectMake(0, 0, 48, 48)];
    [_deleteButton setCenter:CGPointMake(5, 5)];
    [_deleteButton addTarget:self action:@selector(didPressDelete) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setHidden:YES];
    [self addSubview:_deleteButton];
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

- (void)didPressDelete {
  [_delegate deleteSeatView:self];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//  // Drawing code
//  [[TASeatView backgroundImage] drawInRect:[self bounds]];
//}

- (void)dance {
  // Determine whether to start from the left or the right
  int i = rand() % 2;
  // This code was taken (almost) straight from the openspringboard project.
  // https://github.com/fieldforceapp/openspringboard/blob/master/openspringboard/Classes/OpenSpringBoard.m
  CGAffineTransform leftWobble = CGAffineTransformMakeRotation(degreesToRadians( kDanceAnimationRotateDeg * (i ? +1 : -1 ) ));
  CGAffineTransform rightWobble = CGAffineTransformMakeRotation(degreesToRadians( kDanceAnimationRotateDeg * (i ? -1 : +1 ) ));
  CGAffineTransform moveTransform = CGAffineTransformTranslate(rightWobble, -kDanceAnimationTranslateX, -kDanceAnimationTranslateY);
  CGAffineTransform conCatTransform = CGAffineTransformConcat(rightWobble, moveTransform);
  
  _backgroundView.transform = leftWobble;  // starting point
  
  [UIView animateWithDuration:0.1
                        delay:0
                      options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                   animations:^{ _backgroundView.transform = conCatTransform; }
                   completion:nil];
}

- (void)stopDancing {
  [_backgroundView.layer removeAllAnimations];
  _backgroundView.transform = CGAffineTransformIdentity;
}

- (void)setEditing:(BOOL)editing {
  if (editing == _editing) {
    return;
  }
  _editing = editing;
  if (_editing) {
    [self dance];
    [_deleteButton setHidden:NO];
  }
  else {
    [self stopDancing];
    [_deleteButton setHidden:YES];
  }
}

#pragma mark Private Methods

- (CGRect)frameForGridLocation:(CGPoint)unitPoint {
  return CGRectMake(u2p(unitPoint.x), u2p(unitPoint.y), u2p(SEAT_WIDTH_UNITS), u2p(SEAT_HEIGHT_UNITS));
}


@end
