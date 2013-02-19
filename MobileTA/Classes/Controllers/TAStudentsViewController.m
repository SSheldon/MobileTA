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
  NSMutableDictionary *_studentsByLetter;
  NSMutableArray *_studentNameLetters;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = NSLocalizedString(@"Roster", nil);
    self.tabBarItem.image = [UIImage imageNamed:@"roster_tab_icon"];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(testFunc)];
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
  // Build a mapping from first letters to students
  _studentsByLetter = [[NSMutableDictionary alloc] init];
  for (Student *student in self.students) {
    // Get the letter the student's name starts with
    NSString *letter;
    if (student.lastName.length) {
      letter = [[student.lastName substringToIndex:1] uppercaseString];
    } else {
      letter = @"";
    }
    // Add this student to the correct array
    NSMutableArray *studentsForLetter = [_studentsByLetter objectForKey:letter];
    if (studentsForLetter) {
      [studentsForLetter addObject:student];
    }
    else {
      studentsForLetter = [NSMutableArray arrayWithObject:student];
      [_studentsByLetter setObject:studentsForLetter forKey:letter];
    }
  }

  // Sort the students in each array of the dict
  NSArray *sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES selector:@selector(caseInsensitiveCompare:)],
    [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(caseInsensitiveCompare:)],
  ];
  for (NSMutableArray *studentsForLetter in _studentsByLetter.objectEnumerator) {
    [studentsForLetter sortUsingDescriptors:sortDescriptors];
  }

  // Store the keys in a sorted array
  _studentNameLetters = [NSMutableArray arrayWithArray:_studentsByLetter.allKeys];
  [_studentNameLetters sortUsingSelector:@selector(caseInsensitiveCompare:)];

  [self.tableView reloadData];
}

- (Student *)studentAtIndexPath:(NSIndexPath *)indexPath {
  NSString *letter = [_studentNameLetters objectAtIndex:indexPath.section];
  return [[_studentsByLetter objectForKey:letter] objectAtIndex:indexPath.row];
}

- (void)updateStudent:(Student *)student withPreviousData:(NSDictionary *)oldData {
  if (student.lastName != [oldData objectForKey:@"lastName"] ||
      student.firstName != [oldData objectForKey:@"firstName"]) {
    [self reloadStudents];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Support all orientations
  return YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _studentsByLetter.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[_studentsByLetter objectForKey:[_studentNameLetters objectAtIndex:section]] count];
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

- (void)testFunc {
  NSLog(@"Hi");
}

@end
