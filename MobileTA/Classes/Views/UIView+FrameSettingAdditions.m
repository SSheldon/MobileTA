//
//  UIView+FrameSettingAdditions.m
//  MobileTA
//
//  Created by Scott on 4/1/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "UIView+FrameSettingAdditions.h"

@implementation UIView (FrameSettingAdditions)

- (void)setX:(CGFloat)x {
  CGFloat y = self.frame.origin.y;
  [self setFrameOrigin:CGPointMake(x, y)];
}

- (void)setY:(CGFloat)y {
  CGFloat x = self.frame.origin.x;
  [self setFrameOrigin:CGPointMake(x, y)];
}

- (void)setFrameOrigin:(CGPoint)point {
  CGSize size = self.frame.size;
  [self setFrame:CGRectMake(point.x, point.y, size.width, size.height)];
}

- (void)setWidth:(CGFloat)width {
  CGFloat height = self.frame.size.height;
  [self setFrameSize:CGSizeMake(width, height)];
}

- (void)setHeight:(CGFloat)height {
  CGFloat width = self.frame.size.width;
  [self setFrameSize:CGSizeMake(width, height)];
}

- (void)setFrameSize:(CGSize)size {
  CGPoint origin = self.frame.origin;
  [self setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
}

@end
