//
//  TASeatView.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatView.h"

#import "Seat.h"
#import "Student.h"
#import "StudentAttendance.h"

#import "TAGridConstants.h"

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kDanceAnimationRotateDeg 6.0
#define kDanceAnimationTranslateX 1.0
#define kDanceAnimationTranslateY 2.0

#define kCornerRadius 20
#define kBottomBarSize 40

#pragma mark _TASeatViewBackground Interface

@interface _TASeatViewBackground : UIView {
  int16_t _participation;
  UILabel *_nameLabel;
  UILabel *_participationLabel;
  UIColor *_attendanceBarColor;
  StudentAttendanceStatus _status;
}

- (void)clearBar;

- (void)setStudentName:(NSString *)name;
- (void)setAttendanceStatus:(StudentAttendanceStatus)status;
- (void)setParticipationAmount:(int16_t)participation;

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
  if (student) {
    [_backgroundView setStudentName:[student shortenedDisplayName]];
    [_backgroundView setAttendanceStatus:StudentAttendanceStatusPresent];
  }
}

- (void)setStudentAttendance:(StudentAttendance *)studentAttendance {
  if (studentAttendance) {
    [self setStudent:[studentAttendance student]];
    [_backgroundView setParticipationAmount:[studentAttendance participation]];
    [_backgroundView setAttendanceStatus:[studentAttendance status]];
  }
  else {
    [self setStudent:nil];
    [_backgroundView clearBar];
  }
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

#pragma mark _TASeatViewBackground Implementation

@implementation _TASeatViewBackground

@synthesize pattern=_pattern;
@synthesize cornerRadius=_cornerRadius;
@synthesize invalidLocation=_invalidLocation;

+ (UIColor *)colorForAttendanceStatus:(StudentAttendanceStatus)status {
  switch (status) {
    case StudentAttendanceStatusAbsent:   return [UIColor redColor];
    case StudentAttendanceStatusTardy:    return [UIColor yellowColor];
    case StudentAttendanceStatusPresent:  return [UIColor greenColor];
    default:                              return [UIColor clearColor];
  }
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Default pattern should be the TASeatView background image
    [self setPattern:[TASeatView backgroundImage]];
    [self setBackgroundColor:[UIColor clearColor]];
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - kBottomBarSize)];
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
    [_participationLabel setTextColor:[UIColor colorWithRed:(52.0/225.0) green:(52.0/225.0) blue:(52.0/225.0) alpha:1.0]];
    [_participationLabel setFont:[UIFont boldSystemFontOfSize:25.0]];
    [_participationLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_participationLabel];
  }
  return self;
}

- (void)setStudentName:(NSString *)name {
  [_nameLabel setText:name];
}

- (void)setParticipationAmount:(int16_t)participation {
  if (_status != StudentAttendanceStatusTardy && _status != StudentAttendanceStatusPresent) {
    [_participationLabel setText:NSStringFromStudentParticipation(participation)];
  }
  _participation = participation;
}

- (void)setAttendanceStatus:(StudentAttendanceStatus)status {
  if (status != StudentAttendanceStatusTardy && status != StudentAttendanceStatusPresent) {
    [_participationLabel setText:@""];
  }
  else {
    [_participationLabel setText:NSStringFromStudentParticipation(_participation)];
  }
  _attendanceBarColor = [_TASeatViewBackground colorForAttendanceStatus:status];
  _status = status;
  [self setNeedsDisplay];
}

- (void)setInvalidLocation:(BOOL)invalidLocation {
  if (invalidLocation != _invalidLocation) {
    _invalidLocation = invalidLocation;
    [self setNeedsDisplay];
  }
}

- (void)clearBar {
  _status = -1;
  _attendanceBarColor = [_TASeatViewBackground colorForAttendanceStatus:_status];
  [_participationLabel setText:@""];
}

- (void)drawRect:(CGRect)rect {
  // Set the background of the view to be clear
  [[UIColor clearColor] set];
  [[UIBezierPath bezierPathWithRect:[self bounds]] fill];
  // Add the seat texture
  [[UIColor colorWithPatternImage:_pattern] set];
  UIBezierPath *seat = [self seatPath];
  [seat fill];
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
  return [UIBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:_cornerRadius];
}

- (UIBezierPath *)bottomBarPath {
  CGRect bottomBarRect = [self bottomBarRect];
  CGSize roundedRectSize = CGSizeMake(_cornerRadius, _cornerRadius);
  return [UIBezierPath bezierPathWithRoundedRect:bottomBarRect
                               byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                     cornerRadii:roundedRectSize];
}

- (CGRect)bottomBarRect {
  CGSize frameSize = self.bounds.size;
  return CGRectMake(0, frameSize.height - kBottomBarSize, frameSize.width, kBottomBarSize);
}

@end
