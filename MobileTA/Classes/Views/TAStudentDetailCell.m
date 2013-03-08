//
//  TAStudentDetailCell.m
//  MobileTA
//
//  Created by Scott on 3/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentDetailCell.h"

@implementation TAStudentDetailCell

@synthesize controller=_controller;

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
    [self addSubview:plusParticipation];
    [self addSubview:minusParticipation];
    [self addSubview:absent];
    [self addSubview:tardy];
  }
  return self;
}

- (void)layoutSubviews {
  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  // 10px between elements
  CGFloat horizontalSpacing = 10;
  // We want much less space verticaly, as we are already constrained
  CGFloat verticalSpacing = 2;
  NSArray *views = @[absent,tardy,plusParticipation,minusParticipation];
  // There are 2 spaces on either side of the cell, and n-1 spaces between cells
  NSInteger numHorizontalSpaces = 2 + ([views count]-1);
  // The width of the buttons is the width of the page, minus all of the area
  // taken up by spacing, evenly distributed between the 4 buttons
  CGFloat buttonWidth = (width - (horizontalSpacing * numHorizontalSpaces)) / 4;
  // The height of the buttons is just the height of the cell, minus the spacing
  // on either side
  CGFloat buttonHeight = (height - (verticalSpacing * 2));
  // We start with x as the length of the horizontal spacing
  CGFloat x = horizontalSpacing;
  // Always stays here
  CGFloat y = verticalSpacing;
  for (NSUInteger i = 0; i < [views count]; i++) {
    UIView *current = [views objectAtIndex:i];
    [current setFrame:CGRectMake(x,y,buttonWidth,buttonHeight)];
    x = x + buttonWidth + horizontalSpacing;
    [current setNeedsDisplay];
  }
}

- (void)plusParticipation {
  NSLog(@"+1 Participation");
}

- (void)minusParticipation {
  NSLog(@"-1 Participation");
}

- (void)markAbsent {
  NSLog(@"Absent");
}

- (void)markTardy {
  NSLog(@"Tardy");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
