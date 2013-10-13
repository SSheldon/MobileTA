//
//  TAAssignSeatsViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 4/1/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAAssignSeatsViewController.h"

#import "Seat.h"
#import "Section.h"
#import "Student.h"

@implementation TAAssignSeatsViewController {
  Student *_selectedStudent;
}

- (id)init {
  self = [self initWithStyle:UITableViewStylePlain];
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = NSLocalizedString(@"Students", nil);
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(cancel)];
  }
  return self;
}

- (id)initWithSection:(Section *)section seat:(Seat *)seat {
  self = [self initWithStyle:UITableViewStylePlain];
  if (self) {
    _selectedStudent = [seat studentForSection:section];
    self.seat = seat;
    self.section = section;
  }
  return self;
}

- (Student *)studentAtIndexPath:(NSIndexPath *)indexPath {
  return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathOfStudent:(Student *)student {
  return [self.fetchedResultsController indexPathForObject:student];
}

- (void)selectStudent:(Student *)student {
  // Uncheck the cell for the old selected student
  UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:[self indexPathOfStudent:_selectedStudent]];
  oldCell.accessoryType = UITableViewCellAccessoryNone;

  // If we're selecting the same student, instead unselect them
  _selectedStudent = ([_selectedStudent isEqual:student] ? nil : student);

  // Check the cell for the new selected student
  UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:[self indexPathOfStudent:_selectedStudent]];
  newCell.accessoryType = UITableViewCellAccessoryCheckmark;

  if ([self.delegate respondsToSelector:@selector(assignSeatsViewController:didSelectStudent:forSeat:)]) {
    [self.delegate assignSeatsViewController:self didSelectStudent:_selectedStudent forSeat:self.seat];
  }
}

- (void)cancel {
  if ([self.delegate respondsToSelector:@selector(assignSeatsViewControllerDidCancel:)]) {
    [self.delegate assignSeatsViewControllerDidCancel:self];
  }
}

#pragma mark TAFetchedResultsTableView

- (NSFetchRequest *)fetchRequest {
  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
  fetch.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
  fetch.predicate = [NSPredicate predicateWithFormat:@"section = %@ AND (seat = NIL OR SELF = %@)", self.section, _selectedStudent];
  fetch.sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
  ];
  return fetch;
}

- (NSString *)sectionNameKeyPath {
  return @"lastNameIndexTitle";
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *studentCellId = @"StudentCell";
  UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:studentCellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentCellId];
  }
  Student *student = [self studentAtIndexPath:indexPath];
  cell.textLabel.text = student.fullDisplayName;
  cell.accessoryType = ([_selectedStudent isEqual:student] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
  return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return [Student lastNameIndexTitles];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self selectStudent:[self studentAtIndexPath:indexPath]];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
