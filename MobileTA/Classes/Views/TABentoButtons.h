//
//  TABentoButtonsView.h
//  MobileTA
//
//  Created by Scott on 4/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentAttendance.h"

typedef enum {
  TABentoButtonsOrientationLeftButtons,
  TABentoButtonsOrientationRightButtons
} TABentoButtonsOrientation;

@class TABentoButtons;

@protocol TABentoButtonsDelegate <NSObject>

- (void)bentoButtons:(TABentoButtons *)buttons didUpdateValue:(NSInteger)value by:(NSInteger)change;

@end

@interface TABentoButtons : UIView {
  UIView *_buttons;
}

- (id)initWithOrientation:(TABentoButtonsOrientation)orientation;

@property(nonatomic)NSInteger value;
@property(nonatomic)TABentoButtonsOrientation orientation;

@property(nonatomic,strong)UIColor *lineColor;

@property(nonatomic,readonly)UILabel *label;
@property(nonatomic,readonly)UIButton *upButton;
@property(nonatomic,readonly)UIButton *downButton;

@property(nonatomic,weak)id<TABentoButtonsDelegate> delegate;

@end
