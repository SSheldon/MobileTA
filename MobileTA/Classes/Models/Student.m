//
//  Student.m
//  MobileTA
//
//  Created by Scott on 1/31/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Student.h"

@implementation Student

@dynamic first;
@dynamic last;

+ (Student *)studentWithFirstName:(NSString *)firstName lastName:(NSString *)lastName context:(NSManagedObjectContext *)context {
  Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];

  student.first = firstName;
  student.last = lastName;

  return student;
}

+ (NSArray *)fetchStudentsInContext:(NSManagedObjectContext *)context {
  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
  fetch.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
  // TODO(ssheldon): Handle errors
  return [context executeFetchRequest:fetch error:nil];
}

@end
