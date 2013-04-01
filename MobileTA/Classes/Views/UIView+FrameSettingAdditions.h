//
//  UIView+FrameSettingAdditions.h
//  MobileTA
//
//  Created by Scott on 4/1/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameSettingAdditions)

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setFrameOrigin:(CGPoint)point;

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setFrameSize:(CGSize)size;

@end
