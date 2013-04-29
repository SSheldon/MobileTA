//
//  TAGroupsViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/28/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "TAGroupsViewController.h"

@interface TAGroupsViewTest : GHViewTestCase
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation TAGroupsViewTest

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
  TAGroupsViewController *controller = [[TAGroupsViewController alloc] initWithSection:section];
  [controller.tableView reloadData];
  GHVerifyView(controller.view);
}

@end
