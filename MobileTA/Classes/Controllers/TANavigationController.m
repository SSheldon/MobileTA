//
//  TANavigationController.m
//  MobileTA
//
//  Created by Steven Sheldon on 3/26/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TANavigationController.h"

@implementation TANavigationController {
  BOOL _allowKeyboardDismiss;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
  return !_allowKeyboardDismiss;
}

- (void)setDisablesAutomaticKeyboardDismissal:(BOOL)disableKeyboardDismiss {
  _allowKeyboardDismiss = !disableKeyboardDismiss;
}

@end
