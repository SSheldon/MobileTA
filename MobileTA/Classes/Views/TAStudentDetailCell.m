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
//    plusParticipation = [[UIButton alloc] initWithFrame:CGRectZero];
//    minusParticipation = [[UIButton alloc] initWithFrame:CGRectZero];
//    absent = [[UIButton alloc] initWithFrame:CGRectZero];
//    tardy = [[UIButton alloc] initWithFrame:CGRectZero];
  }
  return self;
}

- (void)layoutSubviews {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
