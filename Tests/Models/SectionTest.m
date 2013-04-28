//
//  SectionTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/15/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "AttendanceRecord.h"
#import "Section.h"
#import "Student.h"
#import "StudentAttendance.h"

@interface SectionTest : GHTestCase
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation SectionTest

- (void)setUp {
  self.managedObjectContext = [TATestUtils managedObjectContextForModelsInBundle:[NSBundle mainBundle]];
  if (!self.managedObjectContext) {
    GHFail(@"Could not create in-memory store.");
  }
}

- (void)tearDown {
  self.managedObjectContext = nil;
}

- (void)testNearestRecord {
  Section *section = [Section sectionWithName:nil course:@"CS 428" context:self.managedObjectContext];
  AttendanceRecord *record = [AttendanceRecord attendanceRecordWithDate:[NSDate dateWithTimeIntervalSince1970:1331467200] context:self.managedObjectContext];
  record.section = section;

  GHAssertNil([section attendanceRecordNearestToDate:[NSDate dateWithTimeIntervalSince1970:1331467300] withinTimeInterval:60], nil);
  GHAssertEqualObjects([section attendanceRecordNearestToDate:[NSDate dateWithTimeIntervalSince1970:1331467300] withinTimeInterval:300], record, nil);
}

- (void)testWriteCSV {
  Section *section = [Section sectionWithName:nil course:@"CS 428" context:self.managedObjectContext];

  Student *student = [Student studentWithFirstName:@"Scott" lastName:@"Rice" context:self.managedObjectContext];
  student.nickname = @"Fried";
  student.email = @"address@example.com";
  student.section = section;

  AttendanceRecord *record = [AttendanceRecord attendanceRecordWithContext:self.managedObjectContext];
  record.section = section;

  StudentAttendance *attendance = [StudentAttendance studentAttendanceWithStatus:StudentAttendanceStatusTardy participation:2 context:self.managedObjectContext];
  attendance.attendanceRecord = record;
  attendance.student = student;
  GHAssertTrue([self.managedObjectContext save:nil], @"Could not save managed object changes.");

  NSString *csvString = [section CSVStringWithAttendanceRecord:record];
  NSString *expected = @"Last Name,First Name,Nickname,Email,Attendance,Particpation\nRice,Scott,Fried,address@example.com,Tardy,2\n";
  GHAssertEqualObjects(csvString, expected, nil);
}

- (void)testDisplayName {
  Section *section = [Section sectionWithName:nil course:nil context:self.managedObjectContext];
  GHAssertNil([section displayName], nil);

  section = [Section sectionWithName:nil course:@"CS 428" context:self.managedObjectContext];
  GHAssertEqualObjects([section displayName], @"CS 428", nil);

  section = [Section sectionWithName:@"AD1" course:@"CS 428" context:self.managedObjectContext];
  GHAssertEqualObjects([section displayName], @"CS 428 - AD1", nil);

  section = [Section sectionWithName:@"AD1" course:nil context:self.managedObjectContext];
  GHAssertEqualObjects([section displayName], @"AD1", nil);
}

@end
