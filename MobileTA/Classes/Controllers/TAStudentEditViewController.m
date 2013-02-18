//
//  TAStudentEditViewController.m
//  MobileTA
//
//  Created by Scott on 2/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentEditViewController.h"

@implementation TAStudentEditViewController

@synthesize student=_student;

+ (QRootElement *)formForStudent:(Student *)student {
  QRootElement *root = [[QRootElement alloc] init];
  [root setGrouped:YES];
  // The only difference between adding a student and editing a student
  // We can tell if this is a new object (aka one that hasn't been saved
  // to Core Data yet) by checking if the managedObjectContext has been set.
  if([student managedObjectContext]) {
    root.title = @"Edit Student";
  }
  else {
    root.title = @"Add Student";
  }
  QSection *mainSection = [[QSection alloc] initWithTitle:@""];
  QEntryElement *firstName = [[QEntryElement alloc] initWithTitle:@"First Name" Value:[student firstName] Placeholder:@""];
  [firstName setKey:@"firstName"];
  QEntryElement *lastName = [[QEntryElement alloc] initWithTitle:@"Last Name" Value:[student lastName] Placeholder:@""];
  [lastName setKey:@"lastName"];
  [root addSection:mainSection];
  [mainSection addElement:firstName];
  [mainSection addElement:lastName];
  QSection *controlSection = [[QSection alloc] initWithTitle:@""];
  QButtonElement *saveButton = [[QButtonElement alloc] initWithTitle:@"Save"];
  [saveButton setControllerAction:@"save:"];
  [root addSection:controlSection];
  [controlSection addElement:saveButton];
  return root;
}

- (id)initWithStudent:(Student *)student {
  if([self initWithRoot:[TAStudentEditViewController formForStudent:student]]) {
    // Final initialization
    [self setStudent:student];
  }
  return self;
}

- (void)save:(QButtonElement *)saveButton {
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [self.root fetchValueIntoObject:dict];
  [[self student] setFirstName:[dict objectForKey:@"firstName"]];
  [[self student] setLastName:[dict objectForKey:@"lastName"]];
  // TODO(srice): Handle Errors
  [[self managedObjectContext] save:nil];
  // Save a reference to this now since [self navigationController] will
  // be set to nil after popViewController. After we pop, we need to refresh
  // the table view data
  UINavigationController *currentNavigation = [self navigationController];
  [currentNavigation popViewControllerAnimated:YES];
  // After we pop the view controller, we tell the list view to refresh
  UITableView *listTableView = [(UITableViewController *)[currentNavigation topViewController] tableView];
  [listTableView reloadRowsAtIndexPaths:[listTableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
