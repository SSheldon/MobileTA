//
//  Student.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Student.h"
#import "Seat.h"
#import "Section.h"
#import "StudentAttendance.h"
#import "CHCSVParser.h"

@implementation Student

@dynamic firstName;
@dynamic lastName;
@dynamic nickname;
@dynamic section;
@dynamic attendances;
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
  NSMutableArray *students = [NSMutableArray array];
  for (int i = 0; i < [csvContent count]; i++) {
    NSMutableArray *row = [csvContent objectAtIndex:i];
    Student *student = [Student studentWithFirstName:[row objectAtIndex:1] lastName:[row objectAtIndex:0] context:context];
    [students addObject: student];
  }
  
  return students;
}

+ (NSArray *)studentsFromCSVFile:(NSString *)csvFilePath context:(NSManagedObjectContext *)context {
  NSArray *csvContent = [NSArray arrayWithContentsOfCSVFile:csvFilePath options:CHCSVParserOptionsSanitizesFields];
  return [self studentsFromCSV:csvContent context:context];
}

+ (NSArray *)parseMyCSVFile{
  //get the path to the file in your xcode project's resource path
  NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"roster" ofType:@"csv"];
  return [NSArray arrayWithContentsOfCSVFile:csvFilePath options:CHCSVParserOptionsSanitizesFields];
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

@end
