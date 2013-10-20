//
//  TAStudentsAttendanceViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsAttendanceViewController.h"

#import "Section.h"
#import "Student.h"
#import "TAStudentDetailCell.h"

@implementation TAStudentsAttendanceViewController {
  NSIndexPath *_detailedStudentIndex;
}

- (void)reloadStudent:(Student *)student {
  NSIndexPath *path = [self.fetchedResultsController indexPathForObject:student];
  if (path && self.isViewLoaded) {
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
  }
}

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

- (Student *)studentAtIndexPath:(NSIndexPath *)indexPath {
  return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

#pragma mark TAFetchedResultsTableViewController

- (NSFetchRequest *)fetchRequest {
  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
  fetch.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
  fetch.predicate = [NSPredicate predicateWithFormat:@"section = %@", self.section];
  fetch.sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
  ];
  return fetch;
}

- (NSString *)sectionNameKeyPath {
  return @"lastNameIndexTitle";
}

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath {
  Student *student = [self studentAtIndexPath:indexPath];
  [super deleteObjectAtIndexPath:indexPath];
  // Notify our delegate
  if ([self.delegate respondsToSelector:@selector(viewController:didRemoveStudent:)]) {
    [self.delegate viewController:self didRemoveStudent:student];
  }
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *studentDisplayCellId = @"StudentDisplayCell";
  TAStudentDetailCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:studentDisplayCellId];
  if (!cell) {
    cell = [[TAStudentDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentDisplayCellId];
    cell.delegate = self;
  }
  Student *student = [self studentAtIndexPath:indexPath];
  cell.textLabel.text = student.fullDisplayName;
  [cell setStatus:[self statusForStudent:student]];
  [cell setParticipation:[self particpationForStudent:student]];
  cell.emailButton.enabled = !!student.email;
  return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return [Student lastNameIndexTitles];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isEditing) {
    [self selectStudentToEdit:[self studentAtIndexPath:indexPath]];
  } else {
    _detailedStudentIndex = indexPath;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat rowHeight = tableView.rowHeight;
  if ([indexPath isEqual:_detailedStudentIndex]) {
    return 2 * rowHeight;
  }
  return rowHeight;
}

#pragma mark TAStudentDetailCellDelegate

- (void)studentDetailCellDidMarkAbsent:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:[self.tableView indexPathForCell:cell]];
  StudentAttendanceStatus status = [self markStatus:StudentAttendanceStatusAbsent forStudent:student];
  [cell setStatus:status];
}

- (void)studentDetailCellDidMarkTardy:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:[self.tableView indexPathForCell:cell]];
  StudentAttendanceStatus status = [self markStatus:StudentAttendanceStatusTardy forStudent:student];
  [cell setStatus:status];
}

- (void)studentDetailCellDidAddParticipation:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:[self.tableView indexPathForCell:cell]];
  int16_t participation = [self changeParticipationBy:1 forStudent:student];
  [cell setParticipation:participation];
}

- (void)studentDetailCellDidSubtractParticipation:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:[self.tableView indexPathForCell:cell]];
  int16_t participation = [self changeParticipationBy:-1 forStudent:student];
  [cell setParticipation:participation];
}

- (void)studentDetailCellDidSendEmail:(TAStudentDetailCell *)cell {
  Student *student = [self studentAtIndexPath:[self.tableView indexPathForCell:cell]];
  MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
  [mailController setToRecipients:@[student.email]];
  mailController.mailComposeDelegate = self;
  mailController.modalPresentationStyle = UIModalPresentationFormSheet;
  mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  [self presentViewController:mailController animated:YES completion:nil];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
