//
//  GHTestCase+TAUtils.m
//  MobileTA
//
//  Created by Steven Sheldon on 10/12/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "GHTestCase+TAUtils.h"

#import "TATestAppDelegate.h"

@implementation GHTestCase (TAUtils)

- (TATestAppDelegate *)appDelegate {
  return (TATestAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSManagedObjectContext *)managedObjectContext {
  return self.appDelegate.managedObjectContext;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
  self.appDelegate.managedObjectContext = managedObjectContext;
}

- (void)setUpManagedObjectContext {
  self.managedObjectContext = [TATestUtils managedObjectContextForModelsInBundle:[NSBundle mainBundle]];
  if (!self.managedObjectContext) {
    GHFail(@"Could not create in-memory store.");
  }
}

- (void)saveManagedObjectContext {
  NSError *error = nil;
  BOOL successful = [self.managedObjectContext save:&error];
  GHAssertTrue(successful, @"Could not save managed object changes with error %@", error);
}

@end
