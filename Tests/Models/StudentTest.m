//
//  StudentTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 2/24/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "Student.h"

@interface StudentTest : GHTestCase
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation StudentTest

- (void)setUp {
  self.managedObjectContext = [TATestUtils managedObjectContextForModelsInBundle:[NSBundle mainBundle]];
  if (!self.managedObjectContext) {
    GHFail(@"Could not create in-memory store.");
  }
}

- (void)tearDown {
  self.managedObjectContext = nil;
}

- (void)testFetchStudents {
  Student *student = [Student studentWithFirstName:@"Steven" lastName:@"Sheldon" context:self.managedObjectContext];
  GHAssertEqualStrings(student.firstName, @"Steven", nil);
  GHAssertEqualStrings(student.lastName, @"Sheldon", nil);
  GHAssertTrue([self.managedObjectContext save:nil], @"Could not save managed object changes.");

  NSArray *students = [Student fetchStudentsInContext:self.managedObjectContext];
  GHAssertEquals(students.count, 1U, nil);
  Student *savedStudent = [students objectAtIndex:0];
  GHAssertEqualStrings(savedStudent.firstName, @"Steven", nil);
  GHAssertEqualStrings(savedStudent.lastName, @"Sheldon", nil);
}

- (void)testStudentsFromCSV {
  NSArray *students = [Student studentsFromCSV:[Student parseMyCSVFile] context:self.managedObjectContext];
  GHAssertEquals(students.count, 50U, nil);
  Student *firstStudent = [students objectAtIndex:0];
  GHAssertEqualStrings(firstStudent.firstName, @"Essie", nil);
  GHAssertEqualStrings(firstStudent.lastName, @"Vaill", nil);
}

@end
