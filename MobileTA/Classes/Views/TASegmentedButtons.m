//
//  TASegmentedButtons.m
//  MobileTA
//
//  Created by Ted Kalaw on 4/15/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASegmentedButtons.h"

@implementation TASegmentedButtons

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (self.selectedSegmentIndex == -1) {
    return;
  }
  [self sendActionsForControlEvents:UIControlEventTouchUpInside];
  [super touchesEnded:touches withEvent:event];
}

@end
