//
//  TAStudentsAttendanceViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsAttendanceViewController.h"

#import "TAStudentDisplayCell.h"

@implementation TAStudentsAttendanceViewController

- (StudentAttendanceStatus)statusForStudent:(Student *)student {
  return [self.delegate statusForStudent:student];
}

- (int16_t)particpationForStudent:(Student *)student {
  return [self.delegate particpationForStudent:student];
}

- (StudentAttendanceStatus)markStatus:(StudentAttendanceStatus)status forStudent:(Student *)student {
  return [self.delegate markStatus:status forStudent:student];
}

- (int16_t)changeParticipationBy:(int16_t)value forStudent:(Student *)student {
  return [self.delegate changeParticipationBy:value forStudent:student];
}

- (void)selectStudentToEdit:(Student *)student {
  if ([self.delegate respondsToSelector:@selector(viewController:didSelectStudentToEdit:)]) {
    [self.delegate viewController:self didSelectStudentToEdit:student];
  }
}

#pragma mark TAStudentsViewController

- (void)selectStudent:(Student *)student {
  if (self.editing) {
    [self selectStudentToEdit:student];
  }
  else {
    [self showDetailsForStudent:student];
  }
}

- (UITableViewCell *)createDisplayCellForStudent:(Student *)student {
  static NSString *studentDisplayCellId = @"StudentDisplayCell";
  TAStudentDisplayCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:studentDisplayCellId];
  if (!cell) {
    cell = [[TAStudentDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentDisplayCellId];
  }
  cell.textLabel.text = student.fullDisplayName;
  [cell setStatus:[self statusForStudent:student]];
  [cell setParticipation:[self particpationForStudent:student]];
  return cell;
}

- (UITableViewCell *)createDetailCellForStudent:(Student *)student {
  static NSString *studentDetailCellId = @"StudentDetailCell";
  TAStudentDetailCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:studentDetailCellId];
  if (!cell) {
    cell = [[TAStudentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentDetailCellId];
  }
  cell.delegate = self;
  return cell;
}

#pragma mark TAStudentDetailCellDelegate

- (void)studentDetailCellDidMarkAbsent:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  TAStudentDisplayCell *displayCell = (TAStudentDisplayCell *)[self.tableView cellForRowAtIndexPath:detailedStudentIndex];
  [displayCell setStatus:[self markStatus:StudentAttendanceStatusAbsent forStudent:student]];
}

- (void)studentDetailCellDidMarkTardy:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  TAStudentDisplayCell *displayCell = (TAStudentDisplayCell *)[self.tableView cellForRowAtIndexPath:detailedStudentIndex];
  [displayCell setStatus:[self markStatus:StudentAttendanceStatusTardy forStudent:student]];
}

- (void)studentDetailCellDidAddParticipation:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  TAStudentDisplayCell *displayCell = (TAStudentDisplayCell *)[self.tableView cellForRowAtIndexPath:detailedStudentIndex];
  [displayCell setParticipation:[self changeParticipationBy:1 forStudent:student]];
}

- (void)studentDetailCellDidSubtractParticipation:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:detailedStudentIndex];
  TAStudentDisplayCell *displayCell = (TAStudentDisplayCell *)[self.tableView cellForRowAtIndexPath:detailedStudentIndex];
  [displayCell setParticipation:[self changeParticipationBy:-1 forStudent:student]];
}

@end
