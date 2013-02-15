//
//  TAStudentTableViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 1/30/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsViewController.h"

#import "Student.h"

@implementation TAStudentsViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = NSLocalizedString(@"Roster", nil);
    self.tabBarItem.image = [UIImage imageNamed:@"roster_tab_icon"];
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
  [self.tableView reloadData];
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
  return self.students.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *studentCellId = @"StudentCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studentCellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentCellId];
  }

  Student *student = [self.students objectAtIndex:indexPath.row];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];

  return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  Student *selected = [[self students] objectAtIndex:indexPath.row];
  TAStudentEditViewController *editViewController = [[TAStudentEditViewController alloc] initWithStudent:selected];
  [[self navigationController] pushViewController:editViewController animated:YES];
}

@end
