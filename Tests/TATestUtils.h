//
//  TATestUtils.h
//  MobileTA
//
//  Created by Steven Sheldon on 2/24/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TATestUtils : NSObject

+ (NSManagedObjectContext *)managedObjectContextForModelsInBundle:(NSBundle *)bundle;

@end
