//
//  TAStudent.m
//  MobileTA
//
//  Created by Steven Sheldon on 1/30/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudent.h"

@implementation TAStudent

- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
  self = [super init];
  if (self) {
    self.firstName = firstName;
    self.lastName = lastName;
  }
  return self;
}

@end
