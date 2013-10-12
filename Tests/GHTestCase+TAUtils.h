//
//  GHTestCase+TAUtils.h
//  MobileTA
//
//  Created by Steven Sheldon on 10/12/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

@class TATestAppDelegate;

@interface GHTestCase (TAUtils)

@property (readonly, nonatomic) TATestAppDelegate *appDelegate;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)setUpManagedObjectContext;
- (void)saveManagedObjectContext;

@end
