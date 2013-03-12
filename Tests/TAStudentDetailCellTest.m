//
//  TAStudentDetailCellTest.m
//  MobileTA
//
//  Created by Steven Sheldon on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

#import "TAStudentDetailCell.h"

@interface TAStudentDetailCellTest : GHViewTestCase
@end

@implementation TAStudentDetailCellTest

- (void)test {
  TAStudentDetailCell *cell = [[TAStudentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  cell.frame = CGRectMake(0, 0, 768, 48);
  GHVerifyView(cell);
}

@end
