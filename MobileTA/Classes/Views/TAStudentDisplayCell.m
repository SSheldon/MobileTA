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
@synthesize controller = _controller;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    CGRect b = [self bounds];
    // Makes a view with an origin at the top left corner of the view, with a width of 20px, and whose height
    // is the height of the cell
    _statusView = [[UIView alloc] initWithFrame:CGRectMake(0,0,6,b.size.height)];
    [_statusView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_statusView];
  }
  return self;
}

- (void)setStatus: (NSInteger)status {
  NSLog(@"setStatus: %d", status);
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

@end
