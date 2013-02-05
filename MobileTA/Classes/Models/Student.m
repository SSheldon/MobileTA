//
//  Student.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Student.h"
#import "StudentAttendance.h"
#import "parseCSV.h"

@implementation Student

@dynamic first;
@dynamic last;
@dynamic studentAttendance;

+ (Student *)studentWithFirstName:(NSString *)firstName lastName:(NSString *)lastName context:(NSManagedObjectContext *)context {
  Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
  
  student.first = firstName;
  student.last = lastName;
  
  return student;
}

+ (NSArray *)fetchStudentsInContext:(NSManagedObjectContext *)context {
  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
  fetch.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
  NSMutableArray *csvContent = [self parseMyCSVFile];
  // TODO(ssheldon): Handle errors
  NSMutableArray *students = [NSMutableArray array];
  for (int i = 0; i < [csvContent count]; i++) {
    NSMutableArray *row = [csvContent objectAtIndex:i];
    Student *student = [Student studentWithFirstName:[row objectAtIndex:1] lastName:[row objectAtIndex:0] context:context];
    [students addObject: student];
  }
  
  return students;
  //return [context executeFetchRequest:fetch error:nil];
}

+ (NSMutableArray *)parseMyCSVFile{
  CSVParser *parser = [CSVParser new];
  //get the path to the file in your xcode project's resource path
  NSString *csvFilePath = [[NSBundle mainBundle] pathForResource:@"roster" ofType:@"csv"];
  [parser openFile:csvFilePath];
    
  NSMutableArray *csvContent = [parser parseFile];
  [parser closeFile];
  
  return csvContent;
}

@end
