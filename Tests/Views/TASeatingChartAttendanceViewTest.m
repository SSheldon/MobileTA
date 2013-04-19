//
//  TASeatingChartAttendanceViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/15/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "Student.h"
#import "TASeatingChartAttendanceViewController.h"

@interface TASeatingChartAttendanceViewTest : GHViewTestCase
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation TASeatingChartAttendanceViewTest

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
  Student *student = [Student studentWithFirstName:@"Ted" lastName:@"Kalaw" context:self.managedObjectContext];
  TASeatingChartAttendanceViewController *controller = [[TASeatingChartAttendanceViewController alloc] initWithStudentAttendance:nil student:student];
  [controller viewWillAppear:NO];
  [controller viewDidAppear:NO];
  GHVerifyView(controller.view);
}

@end
