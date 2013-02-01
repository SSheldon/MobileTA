//
//  UIViewController+CoreDataAdditions.h
//  MobileTA
//
//  Created by Scott on 1/31/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TAAppDelegate.h"

@interface UIViewController (CoreDataAdditions)

-(NSManagedObjectContext *)managedObjectContext;

@end
