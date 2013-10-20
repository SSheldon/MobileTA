//
//  TAManagedObjectChangeObserver.h
//  MobileTA
//
//  Created by Steven Sheldon on 10/19/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

typedef NS_OPTIONS(NSUInteger, TAManagedObjectChange) {
  TAManagedObjectChangeInsert = 1 << 0,
  TAManagedObjectChangeUpdate = 1 << 1,
  TAManagedObjectChangeDelete = 1 << 2,
  TAManagedObjectChangeAll    = 0xFF,
};

/*!
 An action to perform with a managed object.
 @param object the managed object
 */
typedef void (^TAManagedObjectActionBlock)(id object);

/*!
 Defines an action to perform on a change to a managed object.
 */
@interface TAManagedObjectChangeAction : NSObject

/*!
 Creates and returns an action.
 @param change the kind of change that should trigger this action
 @param entity the entity of managed objects whose changes should trigger this action,
               or nil for any managed object
 @param predicate the predicate specifying the managed objects whose changes should trigger
                  this action, or nil for any managed object
 @param block the block to perform when this action is triggered
 */
+ (instancetype)actionForChange:(TAManagedObjectChange)change
                         entity:(NSEntityDescription *)entity
                      predicate:(NSPredicate *)predicate
                      withBlock:(TAManagedObjectActionBlock)block;

@end

@interface TAManagedObjectChangeObserver : NSObject

+ (void)performActions:(NSArray *)actions forChangeNotification:(NSNotification *)notification;

@property (copy, nonatomic) NSArray *actions;

- (void)addAction:(TAManagedObjectChangeAction *)action;

- (void)addActionForChange:(TAManagedObjectChange)change
                    entity:(NSEntityDescription *)entity
                 predicate:(NSPredicate *)predicate
                 withBlock:(TAManagedObjectActionBlock)block;

- (void)performActionsForChangeNotification:(NSNotification *)notification;

@end
