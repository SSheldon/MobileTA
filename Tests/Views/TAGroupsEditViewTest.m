//
//  TAGroupsEditViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/28/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "TAGroupsViewController.h"

@interface TAGroupsEditViewTest : GHViewTestCase
@end

@implementation TAGroupsEditViewTest

- (void)test {
  TAGroupsEditViewController *controller = [[TAGroupsEditViewController alloc] initWithGroup:nil];
  controller.view.frame = CGRectMake(0, 0, 768, 960);
  GHVerifyView(controller.view);
}

@end
