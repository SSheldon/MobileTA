//
//  Student.h
//  MobileTA
//
//  Created by Scott on 1/31/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * first;
@property (nonatomic, retain) NSString * last;

@end
