//
//  TATestAppDelegate.h
//  MobileTA
//
//  Created by Steven Sheldon on 10/12/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

@interface TATestAppDelegate : GHUnitIOSAppDelegate <TAAppDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
