//
//  TAManagedObjectChangeObserver.m
//  MobileTA
//
//  Created by Steven Sheldon on 10/19/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAManagedObjectChangeObserver.h"

@interface TAManagedObjectChangeAction ()
@property (assign, nonatomic) TAManagedObjectChange change;
@property (strong, nonatomic) NSEntityDescription *entity;
@property (strong, nonatomic) NSPredicate *predicate;
@property (copy, nonatomic) TAManagedObjectActionBlock block;
@end

@implementation TAManagedObjectChangeAction

+ (instancetype)actionForChange:(TAManagedObjectChange)change
                         entity:(NSEntityDescription *)entity
                      predicate:(NSPredicate *)predicate
                      withBlock:(TAManagedObjectActionBlock)block {
  TAManagedObjectChangeAction *entry = [[self alloc] init];
  entry.change = change;
  entry.entity = entity;
  entry.predicate = predicate;
  entry.block = block;
  return entry;
}

- (BOOL)shouldPerformWithObject:(NSManagedObject *)object forChange:(TAManagedObjectChange)change {
  return (self.change & change) == change &&
    (!self.entity || [self.entity isEqual:object.entity]) &&
    (!self.predicate || [self.predicate evaluateWithObject:object]);
}

-(void)performWithObject:(NSManagedObject *)object forChange:(TAManagedObjectChange)change {
  if ([self shouldPerformWithObject:object forChange:change]) {
    self.block(object);
  }
}

@end

@interface TAManagedObjectChangeObserver ()
@property (strong, nonatomic) NSMutableArray *mutableActions;
@end

@implementation TAManagedObjectChangeObserver

- (id)init {
  self = [super init];
  if (self) {
    _mutableActions = [[NSMutableArray alloc] init];
  }
  return self;
}

- (NSArray *)actions {
  return self.mutableActions;
}

- (void)setActions:(NSArray *)entries {
  self.mutableActions = [entries mutableCopy];
}

- (void)addAction:(TAManagedObjectChangeAction *)action {
  [self.mutableActions addObject:action];
}

- (void)addActionForChange:(TAManagedObjectChange)change
                    entity:(NSEntityDescription *)entity
                 predicate:(NSPredicate *)predicate
                 withBlock:(TAManagedObjectActionBlock)block {
  [self addAction:[TAManagedObjectChangeAction actionForChange:change
                                                        entity:entity
                                                     predicate:predicate
                                                     withBlock:block]];
}

- (void)performActionsForChangeNotification:(NSNotification *)notification {
  [self performActionsForChange:TAManagedObjectChangeInsert
                    withObjects:notification.userInfo[NSInsertedObjectsKey]];
  [self performActionsForChange:TAManagedObjectChangeUpdate
                    withObjects:notification.userInfo[NSUpdatedObjectsKey]];
  [self performActionsForChange:TAManagedObjectChangeDelete
                    withObjects:notification.userInfo[NSDeletedObjectsKey]];
}

- (void)performActionsForChange:(TAManagedObjectChange)change withObjects:(NSSet *)objects {
  for (NSManagedObject *object in objects) {
    for (TAManagedObjectChangeAction *action in self.actions) {
      [action performWithObject:object forChange:change];
    }
  }
}

+ (void)performActions:(NSArray *)actions forChangeNotification:(NSNotification *)notification {
  TAManagedObjectChangeObserver *observer = [[self alloc] init];
  observer.actions = actions;
  [observer performActionsForChangeNotification:notification];
}

@end
