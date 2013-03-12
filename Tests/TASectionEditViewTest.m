//
//  TASectionEditViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "TASectionEditViewController.h"

@interface TASectionEditViewTest : GHViewTestCase
@end

@implementation TASectionEditViewTest

- (void)test {
  TASectionEditViewController *controller = [[TASectionEditViewController alloc] initWithSection:nil];
  [controller.view setFrame:CGRectMake(0, 0, 768, 960)];
  GHVerifyView(controller.view);
}

@end
