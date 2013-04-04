//
//  NSManagedObject+JSON.h
//  MobileTA
//
//  Created by Steven Sheldon on 4/3/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (JSON)

- (NSDictionary *)JSONDictionary;
- (NSData *)JSONDataPrettyPrinted:(BOOL)prettyPrinted;
- (NSString *)JSONStringPrettyPrinted:(BOOL)prettyPrinted;

@end
