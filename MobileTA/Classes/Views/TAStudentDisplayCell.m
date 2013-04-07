//
//  TAStudentDisplayCell.m
//  MobileTA
//
//  Created by Yuwei Chen on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentDisplayCell.h"

@implementation TAStudentDisplayCell

@synthesize statusView =_statusView;
@synthesize participationLabel = _participationLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    // Makes a view with an origin at the top left corner of the view, with a width of 6px, and whose height
    // is the height of the cell
    _statusView = [[UIView alloc] initWithFrame:CGRectZero];
    [_statusView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_statusView];
    
    _participationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_participationLabel setTextAlignment:NSTextAlignmentCenter];
    [_participationLabel setTextColor:[UIColor whiteColor]];
    [_participationLabel setBackgroundColor:[UIColor orangeColor]];
    [_participationLabel setHidden:YES];
    [self addSubview:_participationLabel];

  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  [[self textLabel] setX:15];
  [_statusView setFrame:CGRectMake(0,0,10,height)];
  [_statusView setNeedsDisplay];
  [_participationLabel setFrame:CGRectMake(width-60,0,20,height)];
  [_participationLabel setNeedsDisplay];
}

- (void)setStatus: (NSInteger)status {
  UIColor *color;
  if(status == StudentAttendanceStatusAbsent) {
    color = [UIColor redColor];
  }
  else if(status == StudentAttendanceStatusTardy) {
    color = [UIColor yellowColor];
  }
  else {
    color = [UIColor clearColor];
  }
  [_statusView setBackgroundColor:color];
}

- (void)setParticipation: (NSInteger)participation {
  if (participation != 0) {
    [_participationLabel setHidden:NO];
    [_participationLabel setText:[NSString stringWithFormat:@"%d", participation]];
  }
  else {
    [_participationLabel setHidden:YES];
  }
}

@end
