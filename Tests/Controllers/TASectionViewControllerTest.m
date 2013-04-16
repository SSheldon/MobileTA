//
//  TASectionViewControllerTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/15/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "TASectionViewController.h"
#import "TANavigationController.h"

@interface TASectionViewControllerTest : GHViewTestCase
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation TASectionViewControllerTest

- (void)setUp {
  self.managedObjectContext = [TATestUtils managedObjectContextForModelsInBundle:[NSBundle mainBundle]];
  if (!self.managedObjectContext) {
    GHFail(@"Could not create in-memory store.");
  }
}

- (void)tearDown {
  self.managedObjectContext = nil;
}

- (void)test {
  Section *section = [TATestUtils sampleSectionWithContext:self.managedObjectContext];
  TASectionViewController *controller = [[TASectionViewController alloc] initWithSection:section];
  TANavigationController *navController = [[TANavigationController alloc] initWithRootViewController:controller];
  GHVerifyView(navController.view);

  [controller performSelector:@selector(editStudent:) withObject:nil];
  GHRunForInterval(0.1);
  GHVerifyView(navController.view);
}

@end
