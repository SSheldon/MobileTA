//
//  TAGroupsViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/28/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "GHTestCase+TAUtils.h"
#import "TAGroupsViewController.h"

@interface TAGroupsViewTest : GHViewTestCase
@end

@implementation TAGroupsViewTest

- (void)setUp {
  [super setUp];
  [self setUpManagedObjectContext];
}

- (void)tearDown {
  self.managedObjectContext = nil;
  [super tearDown];
}

- (void)test {
  Section *section = [TATestUtils sampleSectionWithContext:self.managedObjectContext];
  [self saveManagedObjectContext];

  TAGroupsViewController *controller = [[TAGroupsViewController alloc] initWithSection:section];
  [controller.tableView reloadData];
  GHVerifyView(controller.view);
}

@end
