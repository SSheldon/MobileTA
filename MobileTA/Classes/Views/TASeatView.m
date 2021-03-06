//
//  TASeatView.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatView.h"

#import "Seat.h"
#import "Group.h"
#import "Student.h"
#import "StudentAttendance.h"

#import "TAGridConstants.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kDanceAnimationRotateDeg 6.0
#define kDanceAnimationTranslateX 1.0
#define kDanceAnimationTranslateY 2.0

#define kStrokeSize 5
#define kStrokeAdjustment 2

#define kCornerRadius 20
#define kBottomBarSize 40

#pragma mark _TASeatViewBackground Interface

@interface _TASeatViewBackground : UIView {
  UILabel *_nameLabel;
  UILabel *_participationLabel;
  UIColor *_attendanceBarColor;
  UIColor *_groupColor;
}

- (void)setStudentName:(NSString *)name;
- (void)setAttendanceStatus:(StudentAttendanceStatus)status particpation:(int16_t)participation;

@property(nonatomic,strong)UIColor *groupColor;
@property(nonatomic,getter = isInvalidLocation)BOOL invalidLocation;
@property(nonatomic,strong)UIImage *pattern;
@property(nonatomic)CGFloat cornerRadius;

@end

#pragma mark Private Method Interface

@interface TASeatView (PrivateMethods)

- (CGRect)frameForGridLocation:(CGPoint)unitPoint;

@end

#pragma mark Implementation

@implementation TASeatView {
  _TASeatViewBackground *_backgroundView;
}

@synthesize delegate=_delegate;

@synthesize seat=_seat;
@synthesize editing=_editing;
@synthesize deleteButton=_deleteButton;
@synthesize invalidLocation=_invalidLocation;

+ (UIImage *)backgroundImage {
  static UIImage *__shared = nil;
  return (__shared) ? __shared : (__shared = [UIImage imageNamed:@"seat.jpg"]);
}

+ (UIImage *)deleteButtonImage {
  static UIImage *__shared = nil;
  return (__shared) ? __shared : (__shared = [UIImage imageNamed:@"delete_button.png"]);
}

- (id)initWithSeat:(Seat *)seat {
  self = [self initWithFrame:[self frameForGridLocation:[seat location]]];
  if (self) {
    [self setSeat:seat];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    _backgroundView = [[_TASeatViewBackground alloc] initWithFrame:[self bounds]];
    [_backgroundView setCornerRadius:kCornerRadius];
    [self addSubview:_backgroundView];
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setBackgroundImage:[TASeatView deleteButtonImage] forState:UIControlStateNormal];
    [_deleteButton setFrame:CGRectMake(0, 0, 48, 48)];
    [_deleteButton setCenter:CGPointMake(5, 5)];
    [_deleteButton addTarget:self action:@selector(didPressDelete) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setHidden:YES];
    [self addSubview:_deleteButton];
  }
  return self;
}

- (void)setStudent:(Student *)student {
  [_backgroundView setStudentName:[student shortenedDisplayName]];
  [_backgroundView setAttendanceStatus:-1 particpation:0];
  [_backgroundView setGroupColor:[[student group] color]];
}

- (void)setStudent:(Student *)student attendance:(StudentAttendance *)studentAttendance {
  [_backgroundView setStudentName:[student shortenedDisplayName]];
  [_backgroundView setAttendanceStatus:(!student ? -1 : [studentAttendance status])
                          particpation:[studentAttendance participation]];
  [_backgroundView setGroupColor:[[student group] color]];
}

- (void)moveToGridLocation:(CGPoint)unitPoint {
  [self setFrame:[self frameForGridLocation:unitPoint]];
}

- (void)setInvalidLocation:(BOOL)invalidLocation {
  _invalidLocation = invalidLocation;
  // Just pass this along
  [_backgroundView setInvalidLocation:invalidLocation];
}

- (void)didPressDelete {
  if ([_delegate respondsToSelector:@selector(deleteSeatView:)]) {
    [_delegate deleteSeatView:self];
  }
}

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

#pragma mark _TASeatViewBackground Implementation

@implementation _TASeatViewBackground

@synthesize pattern=_pattern;
@synthesize cornerRadius=_cornerRadius;
@synthesize invalidLocation=_invalidLocation;

+ (UIColor *)colorForAttendanceStatus:(StudentAttendanceStatus)status {
  switch (status) {
    case StudentAttendanceStatusAbsent:   return ABSENT_COLOR;
    case StudentAttendanceStatusTardy:    return TARDY_COLOR;
    case StudentAttendanceStatusPresent:  return PRESENT_COLOR;
    default:                              return [UIColor clearColor];
  }
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Default pattern should be the TASeatView background image
    [self setPattern:[TASeatView backgroundImage]];
    [self setBackgroundColor:[UIColor clearColor]];
    CGRect sr = [self seatRect];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(sr.origin.x, sr.origin.y, sr.size.width, sr.size.height - kBottomBarSize)];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [_nameLabel setNumberOfLines:0];
    [_nameLabel setTextAlignment:NSTextAlignmentCenter];
    [_nameLabel setFont:[UIFont systemFontOfSize:25.0]];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:_nameLabel];
    _participationLabel = [[UILabel alloc] initWithFrame:[self bottomBarRect]];
    [_participationLabel setBackgroundColor:[UIColor clearColor]];
    // This is the color Emelyn used in one of our recent projects, so I say
    // fuck it let's steal her work.
    [_participationLabel setTextColor:[UIColor colorWithWhite:(52 / 255.0) alpha:1]];
    [_participationLabel setFont:[UIFont boldSystemFontOfSize:25.0]];
    [_participationLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_participationLabel];
  }
  return self;
}

- (void)setStudentName:(NSString *)name {
  [_nameLabel setText:name];
}

- (void)setAttendanceStatus:(StudentAttendanceStatus)status particpation:(int16_t)participation {
  if (status != StudentAttendanceStatusTardy && status != StudentAttendanceStatusPresent) {
    [_participationLabel setText:nil];
  }
  else {
    [_participationLabel setText:NSStringFromStudentParticipation(participation)];
  }
  _attendanceBarColor = [_TASeatViewBackground colorForAttendanceStatus:status];
  [self setNeedsDisplay];
}

- (void)setInvalidLocation:(BOOL)invalidLocation {
  if (invalidLocation != _invalidLocation) {
    _invalidLocation = invalidLocation;
    [self setNeedsDisplay];
  }
}

- (void)drawRect:(CGRect)rect {
  // Set the background of the view to be clear
  [[UIColor clearColor] set];
  [[UIBezierPath bezierPathWithRect:[self bounds]] fill];
  // Add the seat texture
  [[UIColor colorWithPatternImage:_pattern] set];
  UIBezierPath *seat = [self seatPath];
  [seat fill];
  if (_groupColor) {
    [_groupColor set];
    [seat setLineWidth:kStrokeSize];
    [seat stroke];
  }
  // If the location is invalid, we should overlay a little red. Otherwise, we
  // should draw the bottom bar
  if (_invalidLocation) {
    [[UIColor colorWithRed:1 green:0 blue:0 alpha:.5] set];
    [seat fill];
  }
  else {
    UIBezierPath *bottomBar = [self bottomBarPath];
    [_attendanceBarColor set];
    [bottomBar fill];
  }
}

- (UIBezierPath *)seatPath {
  return [UIBezierPath bezierPathWithRoundedRect:[self seatRect] cornerRadius:_cornerRadius];
}

- (UIBezierPath *)bottomBarPath {
  CGRect bottomBarRect = [self bottomBarRect];
  CGSize roundedRectSize = CGSizeMake(_cornerRadius, _cornerRadius);
  return [UIBezierPath bezierPathWithRoundedRect:bottomBarRect
                               byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                     cornerRadii:roundedRectSize];
}

- (CGRect)seatRect {
  return CGRectInset([self bounds], kStrokeSize, kStrokeSize);
}

- (CGRect)bottomBarRect {
  CGRect r = [self seatRect];
  // If you don't stroke the seat, the bottom bar doesn't need the stroke
  // adjustment
  if (_groupColor) {
    r = CGRectInset(r, kStrokeAdjustment, kStrokeAdjustment-1);
  }
  return CGRectMake(r.origin.x, r.origin.y + (r.size.height - kBottomBarSize), r.size.width, kBottomBarSize);
}

@end
