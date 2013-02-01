//
//  UIViewController+CoreDataAdditions.m
//  MobileTA
//
//  Created by Scott on 1/31/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "UIViewController+CoreDataAdditions.h"

@implementation UIViewController (CoreDataAdditions)

-(NSManagedObjectContext *)managedObjectContext {
    return [(TAAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

@end
