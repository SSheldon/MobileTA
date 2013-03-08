//
//  TASectionsViewController.m
//  MobileTA
//
//  Created by Scott on 2/25/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASectionsViewController.h"

@interface TASectionsViewController ()

@end

@implementation TASectionsViewController {
  NSMutableArray *_tableSections;
}

@synthesize sections=_sections;

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = NSLocalizedString(@"Classes", nil);
    self.navigationItem.rightBarButtonItems = @[
                                                self.editButtonItem,
                                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                              target:self
                                                                                              action:@selector(addNewSection)]
                                                ];
    self.tableView.allowsSelectionDuringEditing = YES;
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                                                               target:self
//                                                                               action:@selector(addNewSection)];
//    self.navigationItem.rightBarButtonItem  = addButton;
    
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
  // Load section if they haven't been set
  if (!self.sections.count) {
    NSArray *sections = [Section fetchSectionsInContext:self.managedObjectContext];
    if (!sections.count) {
      // Insert some sections in the the context
      sections = @[
                   [Section sectionWithName:@"CS 428" context:[self managedObjectContext]],
                   ];
      // TODO(srice): Handle errors
      [self.managedObjectContext save:nil];
    }
    self.sections = sections;
  }
  
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setSections:(NSArray *)sections {
  _sections = [sections copy];
}

- (Section *)sectionAtIndexPath:(NSIndexPath *)indexPath {
  return [[self sections] objectAtIndex:[indexPath row]];
}

- (void)editSection:(Section *)section {
  //  Do nothing right now. In the end the code will most likely look like this though (similar to edit student code)
  TASectionEditViewController *editViewController = [[TASectionEditViewController alloc] initWithSection:section];
  editViewController.delegate = self;
  [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)addNewSection {
  [self editSection:nil];
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
  cell.textLabel.text = [NSString stringWithFormat:@"%@", section];
  
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
    // TODO(ssheldon)
    // jk TODO(srice): Handle Errors
    [[self managedObjectContext] save:nil];
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
  if (section.name != [oldData objectForKey:@"name"]) {
    
  }
}


#pragma mark TASectionEditDelegate

- (void)viewController:(TASectionEditViewController *)viewController savedSection:(Section *)section withPreviousData:(NSDictionary *)oldData
{
  [self updateSection:section withPreviousData:oldData];
}

@end
