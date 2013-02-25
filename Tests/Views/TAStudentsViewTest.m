//
//  TAStudentsViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 2/25/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "Student.h"
#import "TAStudentsViewController.h"

@interface TAStudentsViewTest : GHViewTestCase
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation TAStudentsViewTest

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
  TAStudentsViewController *controller = [[TAStudentsViewController alloc] initWithStyle:UITableViewStylePlain];
  // TODO(ssheldon): Figure out why students don't appear if the view loads after they've been set
  [controller view];
  controller.students = @[
    [Student studentWithFirstName:@"Steven" lastName:@"Sheldon" context:self.managedObjectContext],
    [Student studentWithFirstName:@"Alex" lastName:@"Hendrix" context:self.managedObjectContext]
  ];
  GHVerifyView(controller.view);
}

@end
