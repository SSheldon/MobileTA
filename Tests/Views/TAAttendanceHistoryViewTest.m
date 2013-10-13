//
//  TAAttendanceHistoryViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "GHTestCase+TAUtils.h"
#import "AttendanceRecord.h"
#import "Section.h"
#import "TAAttendanceHistoryViewController.h"

@interface TAAttendanceHistoryViewTest : GHViewTestCase
@end

@implementation TAAttendanceHistoryViewTest

- (void)setUp {
  [super setUp];
  [self setUpManagedObjectContext];
}

- (void)tearDown {
  self.managedObjectContext = nil;
  [super tearDown];
}

- (void)test {
  Section *section = [Section sectionWithName:nil course:@"CS 428" context:self.managedObjectContext];
  [section addAttendanceRecordsObject:
    [AttendanceRecord attendanceRecordForName:@"Discussion Section"
                                         date:[NSDate dateWithTimeIntervalSince1970:1331467200]
                                      context:self.managedObjectContext]];
  [section addAttendanceRecordsObject:
    [AttendanceRecord attendanceRecordForName:@"Exam Review"
                                         date:[NSDate dateWithTimeIntervalSince1970:1331294400]
                                      context:self.managedObjectContext]];
  [self saveManagedObjectContext];

  TAAttendanceHistoryViewController *controller =
    [[TAAttendanceHistoryViewController alloc] initWithSection:section attendanceRecord:nil];
  [controller.tableView reloadData];
  GHVerifyView(controller.view);
}

@end
