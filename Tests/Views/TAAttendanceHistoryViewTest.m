//
//  TAAttendanceHistoryViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "AttendanceRecord.h"
#import "TAAttendanceHistoryViewController.h"

@interface TAAttendanceHistoryViewTest : GHViewTestCase
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation TAAttendanceHistoryViewTest

- (void)setUp {
  self.managedObjectContext = [TATestUtils managedObjectContextForModelsInBundle:[NSBundle mainBundle]];
  if (!self.managedObjectContext) {
    GHFail(@"Could not create in-memory store.");
  }
}

- (void)tearDown {
  self.managedObjectContext = nil;
}

- (void)test {
  TAAttendanceHistoryViewController *controller = [[TAAttendanceHistoryViewController alloc] init];
  [controller view];
  controller.records = @[
    [AttendanceRecord attendanceRecordForName:@"Discussion Section"
                                         date:[NSDate dateWithTimeIntervalSince1970:1331467200]
                                      context:self.managedObjectContext],
    [AttendanceRecord attendanceRecordForName:@"Exam Review"
                                         date:[NSDate dateWithTimeIntervalSince1970:1331294400]
                                      context:self.managedObjectContext]
  ];
  GHVerifyView(controller.view);
}

@end
