//
//  TASegmentedButtons.h
//  MobileTA
//
//  Created by Ted Kalaw on 4/15/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TASegmentedButtons;

@protocol TASegmentedButtonsDelegate <NSObject>
- (void)bentoButtons:(TASegmentedButtons *)buttons didUpdateValue:(NSInteger)value by:(NSInteger)change;

@end

@interface TASegmentedButtons : UISegmentedControl

@end
