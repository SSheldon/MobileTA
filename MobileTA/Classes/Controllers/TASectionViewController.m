//
//  TASectionViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 3/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASectionViewController.h"

@implementation TASectionViewController

- (id)init {
  self = [self initWithStyle:UITableViewStylePlain];
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
      self.title = NSLocalizedString(@"Roster", nil);
      self.navigationItem.rightBarButtonItems = @[
        self.editButtonItem,
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addNewStudent)]
      ];
      self.tableView.allowsSelectionDuringEditing = YES;
    }
    return self;
}

- (id)initWithSection:(Section *)section {
  self = [super init];
  if (self) {
    self.section = section;
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

#if DEBUG
  // If this section is empty, populate it from the sample roster.
  if (!self.section.students.count) {
    NSArray *sampleStudents = [Student studentsFromCSV:[Student parseMyCSVFile] context:self.managedObjectContext];
    [self.section addStudents:[NSSet setWithArray:sampleStudents]];
    [self.managedObjectContext save:nil];
    self.students = sampleStudents;
  }
#endif
}

- (void)setSection:(Section *)section {
  _section = section;
  self.students = [section.students allObjects];
  self.title = section.name;
}

- (void)selectStudent:(Student *)student {
  if(self.tableView.editing) {
    [self editStudent:student];
  }
  else {
    [self showDetailsForStudent:student];
  }
}

- (void)addNewStudent {
  [self editStudent:nil];
}

- (void)editStudent:(Student *)student {
  TAStudentEditViewController *editViewController = [[TAStudentEditViewController alloc] initWithStudent:student];
  editViewController.delegate = self;
  [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)updateStudent:(Student *)student withPreviousData:(NSDictionary *)oldData {
  if (student.lastName != [oldData objectForKey:@"lastName"] ||
      student.firstName != [oldData objectForKey:@"firstName"]) {
    if (!oldData) {
      // Make sure that the section for the student is the correct section
      student.section = self.section;
      [[self managedObjectContext] save:nil];
      // Add the student
      NSMutableArray *new_students = [NSMutableArray arrayWithArray:self.students];
      [new_students addObject:student];
      self.students = new_students;
    } else {
      [self reloadStudents];
    }
  }
}

#pragma mark TAStudentEditDelegate

- (void)viewController:(TAStudentEditViewController *)viewController savedStudent:(Student *)student withPreviousData:(NSDictionary *)oldData {
  [self updateStudent:student withPreviousData:oldData];
}

@end
