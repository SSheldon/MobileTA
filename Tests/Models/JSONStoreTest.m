//
//  JSONStoreTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "JSONStore.h"
#import "Section.h"

@interface MockJSONStore : JSONStore
@property (strong, nonatomic) NSDictionary *dictionariesForEntity;
@end

@implementation MockJSONStore

- (NSArray *)IDStringsForObjectsWithEntityName:(NSString *)name {
  return [[self.dictionariesForEntity objectForKey:name] allKeys];
}

- (NSDictionary *)JSONDictionaryForObjectWithEntityName:(NSString *)name IDString:(NSString *)idString {
  return [[self.dictionariesForEntity objectForKey:name] objectForKey:idString];
}

@end

@interface JSONStoreTest : GHTestCase
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) MockJSONStore *store;
@end

@implementation JSONStoreTest

- (void)setUp {
  NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle mainBundle]]];
  NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
  self.store = (MockJSONStore *)[coordinator addPersistentStoreWithType:[MockJSONStore storeType] configuration:nil URL:nil options:nil error:nil];
  if (self.store) {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = coordinator;
    self.context = context;
  }
  if (!self.context) {
    GHFail(@"Could not create JSON store.");
  }
}

- (void)tearDown {
  self.store = nil;
  self.context = nil;
}

- (void)testFetch {
  self.store.dictionariesForEntity = @{
    @"Section": @{
      @"1": @{
        @"name": @"CS 428",
      },
    },
  };
  NSArray *sections = [Section fetchSectionsInContext:self.context];
  GHAssertEquals(sections.count, 1U, nil);
  Section *section = [sections objectAtIndex:0];
  GHAssertEquals(section.name, @"CS 428", nil);
}

@end
