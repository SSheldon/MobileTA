//
//  TASegmentedButtons.m
//  MobileTA
//
//  Created by Ted Kalaw on 4/15/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASegmentedButtons.h"

@implementation TASegmentedButtons

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (self.selectedSegmentIndex == -1) {
    return;
  }
  [self sendActionsForControlEvents:UIControlEventTouchUpInside];
  [super touchesEnded:touches withEvent:event];
}

@end
