//
//  TASeatingChartViewTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/1/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import "Room.h"
#import "Section.h"
#import "TASeatingChartView.h"

@interface TASeatingChartViewTest : GHViewTestCase
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation TASeatingChartViewTest

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
  Section *section = [TATestUtils sampleSectionWithContext:self.managedObjectContext];
  TASeatingChartView *seatingChart = [[TASeatingChartView alloc] initWithSection:section];
  for (Seat *seat in section.room.seats) {
    [seatingChart addSeat:seat];
  }
  [seatingChart setAttendanceRecord:[section.attendanceRecords anyObject]];
  seatingChart.frame = CGRectMake(0, 0, 320, 320);
  GHVerifyView(seatingChart);
}

@end
