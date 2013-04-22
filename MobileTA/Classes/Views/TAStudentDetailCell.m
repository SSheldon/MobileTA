//
//  TAStudentDetailCell.m
//  MobileTA
//
//  Created by Scott on 3/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentDetailCell.h"

// 10px between elements
#define HORIZONTAL_SPACING 10
// We want much less space verticaly, as we are already constrained
#define VERTICAL_SPACING 4
// Padding on the right hand side to make sure that the button doesn't get
// covered by the index
#define RIGHT_PADDING 20

@implementation TAStudentDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    plusParticipation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [plusParticipation setTitle:@"+1 Participation" forState:UIControlStateNormal];
    [plusParticipation addTarget:self action:@selector(plusParticipation) forControlEvents:UIControlEventTouchUpInside];
    minusParticipation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [minusParticipation setTitle:@"-1 Participation" forState:UIControlStateNormal];
    [minusParticipation addTarget:self action:@selector(minusParticipation) forControlEvents:UIControlEventTouchUpInside];
    absent = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [absent setTitle:@"Mark Absent" forState:UIControlStateNormal];
    [absent addTarget:self action:@selector(markAbsent) forControlEvents:UIControlEventTouchUpInside];
    tardy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // I dunno who Mark is, but we are really hating on him here.
    [tardy setTitle:@"Mark Tardy" forState:UIControlStateNormal];
    [tardy addTarget:self action:@selector(markTardy) forControlEvents:UIControlEventTouchUpInside];
    email = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [email setTitle:@"Send Email" forState:UIControlStateNormal];
    [email addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    [email setEnabled:[self.delegate cellCanSendEmail:self]];
    [self addSubview:plusParticipation];
    [self addSubview:minusParticipation];
    [self addSubview:absent];
    [self addSubview:tardy];
    [self addSubview:email];
  }
  return self;
}

- (void)setDelegate:(id<TAStudentDetailDelegate>)delegate {
  _delegate = delegate;
  [email setEnabled:[self.delegate cellCanSendEmail:self]];
  UIColor *textColor;
  if ([email isEnabled]) {
    textColor = [UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0];
  }
  else {
    textColor = [UIColor grayColor];
  }
  [email setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)layoutSubviews {
  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  NSArray *views = @[absent,tardy,plusParticipation,minusParticipation,email];
  // There are 2 spaces on either side of the cell, and n-1 spaces between cells
  NSInteger numHorizontalSpaces = 2 + ([views count]-1);
  // The width of the buttons is the width of the page, minus all of the area
  // taken up by spacing, evenly distributed between the buttons
  CGFloat buttonWidth = (width - RIGHT_PADDING - (HORIZONTAL_SPACING * numHorizontalSpaces)) / [views count];
  // The height of the buttons is just the height of the cell, minus the spacing
  // on either side
  CGFloat buttonHeight = (height - (VERTICAL_SPACING * 2));
  // We start with x as the length of the horizontal spacing
  CGFloat x = HORIZONTAL_SPACING;
  // Always stays here
  CGFloat y = VERTICAL_SPACING;
  for (NSUInteger i = 0; i < [views count]; i++) {
    UIView *current = [views objectAtIndex:i];
    [current setFrame:CGRectMake(x,y,buttonWidth,buttonHeight)];
    x = x + buttonWidth + HORIZONTAL_SPACING;
    [current setNeedsDisplay];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
