//
//  TASectionViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 3/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "TASectionsViewController.h"
#import "Section.h"

@interface TASectionsViewTest : GHViewTestCase
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation TASectionsViewTest

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
  TASectionsViewController *controller = [[TASectionsViewController alloc] initWithStyle:UITableViewStylePlain];
  [controller view];
  controller.sections = @[
    [Section sectionWithName:@"CS 427" context:self.managedObjectContext],
    [Section sectionWithName:@"CS 428" context:self.managedObjectContext],
  ];
  GHVerifyView(controller.view);
}

@end
