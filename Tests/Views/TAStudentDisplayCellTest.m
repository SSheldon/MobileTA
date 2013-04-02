//
//  TAStudentDisplayCellTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/1/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "TAStudentDisplayCell.h"

@interface TAStudentDisplayCellTest : GHViewTestCase
@end

@implementation TAStudentDisplayCellTest

- (void)test {
  TAStudentDisplayCell *cell = [[TAStudentDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  cell.backgroundColor = [UIColor whiteColor];
  cell.textLabel.text = @"Steven Sheldon";
  [cell setParticipation:2];
  [cell setStatus:StudentAttendanceStatusTardy];
  cell.frame = CGRectMake(0, 0, 768, 48);
  GHVerifyView(cell);
}

@end
