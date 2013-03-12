//
//  TAAttendanceRecordEditViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "TAAttendanceRecordEditViewController.h"

@interface TAAttendanceRecordEditViewTest : GHViewTestCase
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation TAAttendanceRecordEditViewTest

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
  AttendanceRecord *record = [AttendanceRecord attendanceRecordForName:@"Exam Review"
                                                                  date:[NSDate dateWithTimeIntervalSince1970:1331294400]
                                                               context:self.managedObjectContext];
  TAAttendanceRecordEditViewController *controller = [[TAAttendanceRecordEditViewController alloc] initWithAttendanceRecord:record];
  [controller.view setFrame:CGRectMake(0, 0, 768, 960)];
  GHVerifyView(controller.view);
}

@end
