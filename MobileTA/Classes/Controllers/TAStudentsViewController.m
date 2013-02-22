//
//  TAStudentTableViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 1/30/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsViewController.h"

#import "Student.h"

@implementation TAStudentsViewController {
  NSMutableArray *_tableSections;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = NSLocalizedString(@"Roster", nil);
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addNewStudent)];
    self.navigationItem.rightBarButtonItem  = addButton;

  }
  return self;
}

- (void)loadView {
  [super loadView];

  NSArray *students = [Student fetchStudentsInContext:self.managedObjectContext];
  if (!students.count) {
    // Insert some students in the the context
    students = @[
      [Student studentWithFirstName:@"Steven" lastName:@"Sheldon" context:self.managedObjectContext],
      [Student studentWithFirstName:@"Alex" lastName:@"Hendrix" context:self.managedObjectContext]
    ];
    // TODO(ssheldon): Handle errors
    [self.managedObjectContext save:nil];
  }
  self.students = students;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)setStudents:(NSArray *)students {
  _students = students;
  [self reloadStudents];
}

- (void)reloadStudents {
  _tableSections = [[NSMutableArray alloc] init];
  UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];

  // Add an empty student array for each section
  for (NSInteger i = 0; i < collation.sectionTitles.count; i++) {
    [_tableSections addObject:[NSMutableArray array]];
  }

  // Add students to the array in the section determined by their last name
  for (Student *student in self.students) {
    NSInteger sectionNumber = [collation sectionForObject:student collationStringSelector:@selector(lastName)];
    [[_tableSections objectAtIndex:sectionNumber] addObject:student];
  }

  // Sort student array within each section
  NSArray *sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
  ];
  for (NSMutableArray *students in _tableSections) {
    // Sort using descriptors so that we can break ties with first name, which isn't possible with
    // UILocalizedIndexedCollation's sortedArrayFromArray:collationStringSelector:
    [students sortUsingDescriptors:sortDescriptors];
  }

  [self.tableView reloadData];
}

- (Student *)studentAtIndexPath:(NSIndexPath *)indexPath {
  return [[_tableSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (void)updateStudent:(Student *)student withPreviousData:(NSDictionary *)oldData {
  if (student.lastName != [oldData objectForKey:@"lastName"] ||
      student.firstName != [oldData objectForKey:@"firstName"]) {
    if (!oldData) {
      NSMutableArray *new_students = [NSMutableArray arrayWithArray:self.students];
      [new_students addObject:student];
      self.students = new_students;
    }
    [self reloadStudents];
  }
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
  return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *studentCellId = @"StudentCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studentCellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentCellId];
  }

  Student *student = [self studentAtIndexPath:indexPath];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];

  return cell;
}

- (void)addNewStudent {
  TAStudentEditViewController *editViewController = [[TAStudentEditViewController alloc] initWithStudent:nil];
  [editViewController setDelegate:self];
  [[self navigationController] pushViewController:editViewController animated:YES];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  Student *selected = [self studentAtIndexPath:indexPath];
  TAStudentEditViewController *editViewController = [[TAStudentEditViewController alloc] initWithStudent:selected];
  [editViewController setDelegate:self];
  [[self navigationController] pushViewController:editViewController animated:YES];
}

#pragma mark TAStudentEditDelegate

- (void)viewController:(TAStudentEditViewController *)viewController savedStudent:(Student *)student withPreviousData:(NSDictionary *)oldData {
  [self updateStudent:student withPreviousData:oldData];
}


@end
