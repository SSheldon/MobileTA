//
//  TASectionViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 3/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "GHTestCase+TAUtils.h"
#import "TASectionsViewController.h"
#import "Section.h"

@interface TASectionsViewTest : GHViewTestCase
@end

@implementation TASectionsViewTest

- (void)setUp {
  [super setUp];
  [self setUpManagedObjectContext];
}

- (void)tearDown {
  self.managedObjectContext = nil;
  [super tearDown];
}

- (void)test {
  [Section sectionWithName:@"AD1" course:@"SP13 CS428" context:self.managedObjectContext];
  [Section sectionWithName:@"AD2" course:@"SP13 CS428" context:self.managedObjectContext];
  [self saveManagedObjectContext];

  TASectionsViewController *controller = [[TASectionsViewController alloc] initWithStyle:UITableViewStylePlain];
  [controller.tableView reloadData];
  GHVerifyView(controller.view);
}

@end
