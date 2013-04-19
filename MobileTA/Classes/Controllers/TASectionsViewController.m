//
//  TASectionsViewController.m
//  MobileTA
//
//  Created by Scott on 2/25/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASectionsViewController.h"

@implementation TASectionsViewController {
  // array of array of Section object
  NSMutableArray *_tableSections;
  // array of NSString that contain the name of each section
  NSMutableArray *_tableSectionsTitle;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = NSLocalizedString(@"Sections", nil);
    self.navigationItem.rightBarButtonItems = @[
      self.editButtonItem,
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                    target:self
                                                    action:@selector(addNewSection)]
    ];
    self.tableView.allowsSelectionDuringEditing = YES;
    _tableSectionsTitle = [[NSMutableArray alloc] init];
    _tableSections = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)setSections:(NSArray *)sections {
  _sections = [sections copy];
  _sections = [_sections sortedArrayUsingSelector:@selector(compare:)];
  _tableSectionsTitle = [[NSMutableArray alloc] init];
  _tableSections = [[NSMutableArray alloc] init];
  for (Section *section in _sections) {
    if ([_tableSectionsTitle containsObject
         :section.course]) {
      NSInteger index = [_tableSectionsTitle indexOfObject:section.course];
      [_tableSections[index] addObject:section];
    } else {
      [_tableSectionsTitle addObject:section.course];
      [_tableSections addObject:[NSMutableArray arrayWithObject:section]];
    }
  }
  if ([self isViewLoaded]) {
    [self.tableView reloadData];
  }
}

- (Section *)sectionAtIndexPath:(NSIndexPath *)indexPath {
  return [[_tableSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (void)editSection:(Section *)section {
  TASectionEditViewController *editViewController = [[TASectionEditViewController alloc] initWithSection:section];
  editViewController.delegate = self;
  [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)addNewSection {
  [self editSection:nil];
}

- (void)addSectionWithStudents:(NSArray *)students {
  Section *section = [Section sectionWithName:nil course:@"IMPORTED" context:self.managedObjectContext];
  [section addStudents:[NSSet setWithArray:students]];
  [self saveManagedObjectContext];
  self.sections = [self.sections arrayByAddingObject:section];
  [self editSection:section];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Support all orientations
  return YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _tableSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[_tableSections objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  // Ensure this header isn't shown if we have no rows in the section
  if (![[_tableSections objectAtIndex:section] count]) {
    return nil;
  }
  return [_tableSectionsTitle objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *sectionCellId = @"SectionCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sectionCellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sectionCellId];
  }
  
  Section *section = [[_tableSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];  
  // Section *section = [self sectionAtIndexPath:indexPath];
  cell.textLabel.text = [section displayName];
  
  return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if(editingStyle == UITableViewCellEditingStyleDelete) {
    // Remove the student at that index from the database
    Section *section = [self sectionAtIndexPath:indexPath];
    [[self managedObjectContext] deleteObject:section];
    [self saveManagedObjectContext];
    // Remove student from the Students array
    NSMutableArray *mutableSections = [[self sections] mutableCopy];
    [mutableSections removeObject:section];
    [self setSections:[NSArray arrayWithArray:mutableSections]];
    [[self tableView] reloadData];
  }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(self.tableView.editing) {
    [self editSection:[self sectionAtIndexPath:indexPath]];
  }
  else {
    TASectionViewController *listViewController = [[TASectionViewController alloc] initWithSection:[self sectionAtIndexPath:indexPath]];
    [[self navigationController] pushViewController:listViewController animated:YES];
  }
}

- (void)updateSection:(Section *)section withPreviousData:(NSDictionary *)oldData {
  // If we are editing, then the EditViewController will have done all the work
  // for us (saved the changes to the edited section). If it is a new section,
  // then we need to add it to our sections array
  if(!oldData) {
    self.sections = [self.sections arrayByAddingObject:section];
  }
  [[self tableView] reloadData];
}


#pragma mark TASectionEditDelegate

- (void)viewController:(TASectionEditViewController *)viewController savedSection:(Section *)section withPreviousData:(NSDictionary *)oldData
{
  [self saveManagedObjectContext];
  [self updateSection:section withPreviousData:oldData];
}

@end
