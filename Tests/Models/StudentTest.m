//
//  StudentTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 2/24/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "Section.h"
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
  GHAssertFalse([self.managedObjectContext save:nil], @"Save should fail since students require a section.");

  Section *section = [Section sectionWithName:@"CS 428" context:self.managedObjectContext];
  student.section = section;
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

- (void)testFullDisplayName {
  Student *steven = [Student studentWithFirstName:@"Steven" lastName:@"Sheldon" context:self.managedObjectContext];
  GHAssertEqualStrings([steven fullDisplayName], @"Steven Sheldon", nil);
  Student *alex = [Student studentWithFirstName:@"Alex" lastName:@"Hendrix" context:self.managedObjectContext];
  GHAssertEqualStrings([alex fullDisplayName], @"Alex Hendrix", nil);
}

- (void)testShortenedDisplayName {
  Student *steven = [Student studentWithFirstName:@"Steven" lastName:@"Sheldon" context:self.managedObjectContext];
  GHAssertEqualStrings([steven shortenedDisplayName], @"Steven S.", nil);
  Student *alex = [Student studentWithFirstName:@"Alex" lastName:@"Hendrix" context:self.managedObjectContext];
  GHAssertEqualStrings([alex shortenedDisplayName], @"Alex H.", nil);
}

- (void)testNicknameOverridesFirstName {
  Student *scott = [Student studentWithFirstName:@"Scott" lastName:@"Rice" context:self.managedObjectContext];
  [scott setNickname:@"Fried"];
  
  GHAssertEqualStrings([scott fullDisplayName], @"Fried Rice", nil);
  GHAssertEqualStrings([scott shortenedDisplayName], @"Fried R.", nil);
}

@end
