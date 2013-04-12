//
//  TASectionsViewController.m
//  MobileTA
//
//  Created by Scott on 2/25/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASectionsViewController.h"

@implementation TASectionsViewController

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
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  // Load section if they haven't been set
  if (!self.sections.count) {
    NSArray *sections = [Section fetchSectionsInContext:self.managedObjectContext];
#if DEBUG
    if (!sections.count) {
      // Insert some sections in the the context
      sections = @[
        [Section sectionWithName:@"AD1" course:@"SP13 CS428" context:[self managedObjectContext]],
      ];
      [self saveManagedObjectContext];
    }
#endif
    self.sections = sections;
  }
}

- (void)setSections:(NSArray *)sections {
  _sections = [sections copy];
  if ([self isViewLoaded]) {
    [self.tableView reloadData];
  }
}

- (Section *)sectionAtIndexPath:(NSIndexPath *)indexPath {
  return [[self sections] objectAtIndex:[indexPath row]];
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
  NSMutableArray *sections = [self.sections mutableCopy];
  [sections addObject:section];
  self.sections = sections;
  [self editSection:section];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Support all orientations
  return YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *sectionCellId = @"SectionCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sectionCellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sectionCellId];
  }
  
  Section *section = [self sectionAtIndexPath:indexPath];
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
    NSMutableArray *tempSections = [NSMutableArray arrayWithArray:[self sections]];
    [tempSections addObject:section];
    [self setSections:[NSArray arrayWithArray:tempSections]];
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
