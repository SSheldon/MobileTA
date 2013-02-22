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
  NSMutableDictionary *_students;
  NSMutableArray *_studentNameLetters;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = NSLocalizedString(@"Roster", nil);
    self.tabBarItem.image = [UIImage imageNamed:@"roster_tab_icon"];
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
  _students = [[NSMutableDictionary alloc] init];
  for (Student *student in students) {
    // Get the letter the student's name starts with
    NSString *letter;
    if (student.lastName.length) {
      letter = [student.lastName substringToIndex:1];
    } else {
      letter = @"";
    }
    // Add this student to the correct array
    NSMutableArray *studentsForLetter = [_students objectForKey:letter];
    if (studentsForLetter) {
      [studentsForLetter addObject:student];
    }
    else {
      studentsForLetter = [NSMutableArray arrayWithObject:student];
      [_students setObject:studentsForLetter forKey:letter];
    }
  }
  // TODO(ssheldon): Sort the students in each array of the dict

  _studentNameLetters = [NSMutableArray arrayWithArray:_students.allKeys];
  [_studentNameLetters sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  [self.tableView reloadData];
}

- (Student *)studentAtIndexPath:(NSIndexPath *)indexPath {
  return [[_students objectForKey:[_studentNameLetters objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Support all orientations
  return YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _students.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[_students objectForKey:[_studentNameLetters objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [_studentNameLetters objectAtIndex:section];
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
  [[self navigationController] pushViewController:editViewController animated:YES];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  Student *selected = [self studentAtIndexPath:indexPath];
  TAStudentEditViewController *editViewController = [[TAStudentEditViewController alloc] initWithStudent:selected];
  [[self navigationController] pushViewController:editViewController animated:YES];
}

@end
