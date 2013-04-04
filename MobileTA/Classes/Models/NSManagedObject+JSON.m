//
//  NSManagedObject+JSON.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/3/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "NSManagedObject+JSON.h"

@implementation NSManagedObject (JSON)

+ (NSString *)JSONStringForObjectID:(NSManagedObjectID *)objectID {
  return [objectID.URIRepresentation.pathComponents lastObject];
}

- (NSString *)JSONStringForObjectID {
  return [NSManagedObject JSONStringForObjectID:self.objectID];
}

- (id)JSONObjectForAttribute:(NSAttributeDescription *)attribute {
  if (attribute.isTransient) {
    return nil;
  }

  id value = [self valueForKey:attribute.name];

  if (!value) {
    if (attribute.isOptional) {
      return nil;
    }
    return [NSNull null];
  }

  // Based on the attribute type, perform any additional conversion
  switch (attribute.attributeType) {
    case NSDateAttributeType:
      return [NSNumber numberWithDouble:[(NSDate *)value timeIntervalSince1970]];
  }

  return value;
}

- (id)JSONObjectForRelationship:(NSRelationshipDescription *)relationship {
  if (relationship.isTransient) {
    return nil;
  }

  id value = [self valueForKey:relationship.name];

  if (!value) {
    if (relationship.isOptional) {
      return nil;
    }
    return [NSNull null];
  }

  if (!relationship.isToMany) {
    return [(NSManagedObject *)value JSONStringForObjectID];
  }

  NSMutableArray *array = [NSMutableArray array];
  for (NSManagedObject *object in value) {
    [array addObject:[object JSONStringForObjectID]];
  }
  return array;
}

- (NSDictionary *)JSONDictionary {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];

  NSDictionary *attributes = self.entity.attributesByName;
  for (NSString *name in attributes) {
    id value = [self JSONObjectForAttribute:[attributes objectForKey:name]];
    if (value) {
      [dict setObject:value forKey:name];
    }
  }

  NSDictionary *relationships = self.entity.relationshipsByName;
  for (NSString *name in relationships) {
    id value = [self JSONObjectForRelationship:[relationships objectForKey:name]];
    if (value) {
      [dict setObject:value forKey:name];
    }
  }

  return dict;
}

- (NSData *)JSONDataPrettyPrinted:(BOOL)prettyPrinted {
  NSJSONWritingOptions options = (prettyPrinted ? NSJSONWritingPrettyPrinted : 0);
  NSDictionary *dict = [self JSONDictionary];
  return [NSJSONSerialization dataWithJSONObject:dict options:options error:NULL];
}

- (NSString *)JSONStringPrettyPrinted:(BOOL)prettyPrinted {
  NSData *data = [self JSONDataPrettyPrinted:prettyPrinted];
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
