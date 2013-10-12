//
//  TASectionsViewController.m
//  MobileTA
//
//  Created by Scott on 2/25/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASectionsViewController.h"

#import "Section.h"
#import "TASectionViewController.h"

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
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.allowsSelectionDuringEditing = YES;
}

- (Section *)sectionAtIndexPath:(NSIndexPath *)indexPath {
  return [self.fetchedResultsController objectAtIndexPath:indexPath];
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
  [self editSection:section];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Support all orientations
  return YES;
}

#pragma mark TAFetchedResultsTableViewController

- (NSFetchRequest *)fetchRequest {
  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
  fetch.entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:self.managedObjectContext];
  fetch.sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"course" ascending:YES],
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES],
  ];
  return fetch;
}

- (NSString *)sectionNameKeyPath {
  return @"course";
}

#pragma mark UITableViewDataSource

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


#pragma mark TASectionEditDelegate

- (void)viewController:(TASectionEditViewController *)viewController savedSection:(Section *)section withPreviousData:(NSDictionary *)oldData {
  [self saveManagedObjectContext];
}

@end
