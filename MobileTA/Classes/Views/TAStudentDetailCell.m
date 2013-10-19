//
//  TAStudentDetailCell.m
//  MobileTA
//
//  Created by Scott on 3/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentDetailCell.h"

#import "StudentAttendance.h"
#import "TAGridConstants.h"

@interface TAStudentDetailCell ()
@property (strong, nonatomic) UIView *statusView;
@property (strong, nonatomic) UILabel *participationLabel;
@property (retain, nonatomic) NSArray *buttons;
@end

@implementation TAStudentDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.clipsToBounds = YES;

    // Makes a view with an origin at the top left corner of the view, with a width of 6px, and whose height
    // is the height of the cell
    _statusView = [[UIView alloc] initWithFrame:CGRectZero];
    _statusView.backgroundColor = [UIColor clearColor];
    [self addSubview:_statusView];

    _participationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _participationLabel.textAlignment = NSTextAlignmentCenter;
    _participationLabel.textColor = [UIColor whiteColor];
    _participationLabel.backgroundColor = PARTICIPATION_COLOR;
    _participationLabel.hidden = YES;
    [self addSubview:_participationLabel];

    UIButton *plusParticipation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [plusParticipation setTitle:@"+1 Participation" forState:UIControlStateNormal];
    [plusParticipation addTarget:self action:@selector(plusParticipation) forControlEvents:UIControlEventTouchUpInside];

    UIButton *minusParticipation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [minusParticipation setTitle:@"-1 Participation" forState:UIControlStateNormal];
    [minusParticipation addTarget:self action:@selector(minusParticipation) forControlEvents:UIControlEventTouchUpInside];

    UIButton *absent = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [absent setTitle:@"Mark Absent" forState:UIControlStateNormal];
    [absent addTarget:self action:@selector(markAbsent) forControlEvents:UIControlEventTouchUpInside];

    UIButton *tardy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // I dunno who Mark is, but we are really hating on him here.
    [tardy setTitle:@"Mark Tardy" forState:UIControlStateNormal];
    [tardy addTarget:self action:@selector(markTardy) forControlEvents:UIControlEventTouchUpInside];

    UIButton *email = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [email setTitle:@"Send Email" forState:UIControlStateNormal];
    [email addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];

    _buttons = @[plusParticipation, minusParticipation, absent, tardy, email];
    for (UIButton *button in _buttons) {
      [self addSubview:button];
    }
  }
  return self;
}

- (UIButton *)emailButton {
  return [self.buttons lastObject];
}

- (void)setStatus:(StudentAttendanceStatus)status {
  UIColor *color;
  if (status == StudentAttendanceStatusAbsent) {
    color = ABSENT_COLOR;
  } else if (status == StudentAttendanceStatusTardy) {
    color = TARDY_COLOR;
  } else {
    color = [UIColor clearColor];
  }
  _statusView.backgroundColor = color;
}

- (void)setParticipation:(int16_t)participation {
  if (participation != 0) {
    _participationLabel.hidden = NO;
    _participationLabel.text = [NSString stringWithFormat:@"%d", participation];
  } else {
    _participationLabel.hidden = YES;
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;

  [self.textLabel setFrameOrigin:CGPointMake(15, 10)];
  [self.textLabel sizeToFit];

  _statusView.frame = CGRectMake(0, 0, 10, height);
  [_statusView setNeedsDisplay];

  static const CGFloat halfHeight = 44;
  _participationLabel.frame = CGRectMake(width - 60, 0, 20, halfHeight);
  [_participationLabel setNeedsDisplay];

  // 10px between elements
  static const CGFloat horizontalSpacing = 10;
  // We want much less space verticaly, as we are already constrained
  static const CGFloat verticalSpacing = 4;
  // Padding on the right hand side to make sure that the button doesn't get
  // covered by the index
  static const CGFloat rightPadding = 20;
  // The height of the buttons is just the height of the bottom half,
  // minus the spacing on either side
  static const CGFloat buttonHeight = halfHeight - (verticalSpacing * 2);

  // There are 2 spaces on either side of the cell, and n-1 spaces between buttons
  NSInteger numHorizontalSpaces = 2 + (self.buttons.count - 1);
  // The width of the buttons is the width of the page, minus all of the area
  // taken up by spacing, evenly distributed between the buttons
  CGFloat buttonWidth = (width - rightPadding - (horizontalSpacing * numHorizontalSpaces)) / self.buttons.count;
  // We start with x as the length of the horizontal spacing
  CGFloat x = horizontalSpacing;
  // Always stays here
  CGFloat y = halfHeight + verticalSpacing;

  for (UIButton *button in self.buttons) {
    button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
    [button setNeedsDisplay];
    x += buttonWidth + horizontalSpacing;
  }
}

- (void)plusParticipation {
  [self.delegate studentDetailCellDidAddParticipation:self];
}

- (void)minusParticipation {
  [self.delegate studentDetailCellDidSubtractParticipation:self];
}

- (void)markAbsent {
  [self.delegate studentDetailCellDidMarkAbsent:self];
}

- (void)markTardy {
  [self.delegate studentDetailCellDidMarkTardy:self];
}

- (void)sendEmail {
  [self.delegate studentDetailCellDidSendEmail:self];
}

@end
