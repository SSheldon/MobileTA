//
//  TATestUtils.m
//  MobileTA
//
//  Created by Steven Sheldon on 2/24/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TATestUtils.h"

@implementation TATestUtils

+ (NSManagedObjectContext *)managedObjectContextForModelsInBundle:(NSBundle *)bundle {
  NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:bundle]];
  NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
  NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
  if (!store) {
    return nil;
  }
  NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
  context.persistentStoreCoordinator = coordinator;
  return context;
}

@end
