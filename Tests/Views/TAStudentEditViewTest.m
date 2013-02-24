//
//  TAStudentEditViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 2/23/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "TAStudentEditViewController.h"

@interface TAStudentEditViewTest : GHViewTestCase
@end

@implementation TAStudentEditViewTest

- (void)test {
  TAStudentEditViewController *controller = [[TAStudentEditViewController alloc] initWithStudent:nil];
  [controller.view setFrame:CGRectMake(0, 0, 768, 960)];
  GHVerifyView(controller.view);
}

@end
