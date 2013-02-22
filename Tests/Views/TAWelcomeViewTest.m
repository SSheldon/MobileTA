//
//  TAWelcomeViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 2/21/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "TAWelcomeViewController.h"

@interface TAWelcomeViewTest : GHViewTestCase
@end

@implementation TAWelcomeViewTest

- (void)test {
  TAWelcomeViewController *controller = [[TAWelcomeViewController alloc] initWithNibName:nil bundle:nil];
  GHVerifyView(controller.view);
}

@end
