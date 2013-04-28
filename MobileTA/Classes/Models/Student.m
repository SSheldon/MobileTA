//
//  Student.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Student.h"
#import "Group.h"
#import "Seat.h"
#import "Section.h"
#import "StudentAttendance.h"
#import "CHCSVParser.h"

@interface NSArray (SafeGet)

- (id)safeObjectAtIndex:(NSUInteger)index;

@end

@implementation NSArray (SafeGet)

- (id)safeObjectAtIndex:(NSUInteger)index {
  return (index >= self.count ? nil : [self objectAtIndex:index]);
}

@end

@implementation Student

@dynamic firstName;
@dynamic lastName;
@dynamic nickname;
@dynamic email;
@dynamic notes;
@dynamic section;
@dynamic attendances;
@dynamic group;
@dynamic seat;

+ (Student *)studentWithFirstName:(NSString *)firstName lastName:(NSString *)lastName context:(NSManagedObjectContext *)context {
  Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];

  student.firstName = firstName;
  student.lastName = lastName;

  return student;
}


+ (NSArray *)fetchStudentsInContext:(NSManagedObjectContext *)context {
  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
  fetch.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
  // TODO(ssheldon): Handle errors
  return [context executeFetchRequest:fetch error:nil];
}

+ (NSArray *)studentsFromCSV:(NSArray *)csvContent context:(NSManagedObjectContext *)context {
  NSArray *header = [csvContent safeObjectAtIndex:0];
  NSUInteger firstNameIndex = [header indexOfObject:@"First Name"];
  NSUInteger lastNameIndex = [header indexOfObject:@"Last Name"];
  NSUInteger nicknameIndex = [header indexOfObject:@"Nickname"];
  NSUInteger emailIndex = [header indexOfObject:@"Email"];

  NSMutableArray *students = [NSMutableArray array];
  for (NSUInteger i = 1; i < [csvContent count]; i++) {
    NSMutableArray *row = [csvContent objectAtIndex:i];
    Student *student = [Student studentWithFirstName:[row safeObjectAtIndex:firstNameIndex]
                                            lastName:[row safeObjectAtIndex:lastNameIndex]
                                             context:context];
    student.nickname = [row safeObjectAtIndex:nicknameIndex];
    student.email = [row safeObjectAtIndex:emailIndex];
    [students addObject:student];
  }
  
  return students;
}

+ (NSArray *)studentsFromCSVFile:(NSString *)csvFilePath context:(NSManagedObjectContext *)context {
  NSArray *csvContent = [NSArray arrayWithContentsOfCSVFile:csvFilePath options:CHCSVParserOptionsSanitizesFields];
  return [self studentsFromCSV:csvContent context:context];
}

- (NSString *)fullDisplayName {
  NSString *display = nil;
  // Start with the student's nickname or first name
  if (self.nickname.length) {
    display = self.nickname;
  } else if (self.firstName.length) {
    display = self.firstName;
  }

  // Add the student's last name
  if (self.lastName.length) {
    if (display.length) {
      display = [display stringByAppendingFormat:@" %@", self.lastName];
    } else {
      display = self.lastName;
    }
  }

  return display;
}

- (NSString *)shortenedDisplayName {
  NSString *firstDisplayName = nil;
  if (self.nickname.length) {
    firstDisplayName = self.nickname;
  }
  else {
    firstDisplayName = self.firstName;
  }
  
  if (!self.lastName.length) {
    return firstDisplayName;
  }
  else {
    unichar lastNameInitial = [self.lastName characterAtIndex:0];
    return [NSString stringWithFormat:@"%@ %c.", firstDisplayName, lastNameInitial];
  }
}

- (NSInteger)totalParticipationInContext:(NSManagedObjectContext*)context {
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"StudentAttendance" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"ANY student == %@", self]];
  
  [request setResultType:NSDictionaryResultType];
  
  // Create an expression for the key path.
  NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"participation"];
  
  // Create an expression to represent the sum value at the key path 'creationDate'
  NSExpression *sumExpression = [NSExpression expressionForFunction:@"sum:" arguments:[NSArray arrayWithObject:keyPathExpression]];
  
  NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
  
  // The name is the key that will be used in the dictionary for the return value.
  [expressionDescription setName:@"sumParticipation"];
  [expressionDescription setExpression:sumExpression];
  [expressionDescription setExpressionResultType:NSInteger32AttributeType];
  
  // Set the request's properties to fetch just the property represented by the expressions.
  [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
  
  // Execute the fetch.
  NSError *error = nil;
  NSArray *objects = [context executeFetchRequest:request error:&error];
  if (objects == nil) {
    // Handle the error.
  }
  else {
    if ([objects count] > 0) {
    }
  }
  return [[[objects objectAtIndex:0] valueForKey:@"sumParticipation"] integerValue];
}


@end
