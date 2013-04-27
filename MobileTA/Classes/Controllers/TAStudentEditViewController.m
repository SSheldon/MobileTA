//
//  TAStudentEditViewController.m
//  MobileTA
//
//  Created by Scott on 2/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentEditViewController.h"

#import "Section.h"
#import "Group.h"

@implementation TAStudentEditViewController

+ (QRootElement *)formForStudent:(Student *)student withGroupOptions:(NSArray *)groups{
  QRootElement *root = [[QRootElement alloc] init];
  [root setGrouped:YES];
  // The only difference between adding a student and editing a student
  // We can tell if this is a new object (aka one that hasn't been saved
  // to Core Data yet) by checking if the managedObjectContext has been set.

  if(student) {
    root.title = @"Edit Student";
  }
  else {
    root.title = @"Add Student";
  }
  
  QSection *mainSection = [[QSection alloc] initWithTitle:@""];
  QEntryElement *firstName = [[QEntryElement alloc] initWithTitle:@"First Name" Value:[student firstName] Placeholder:@"John"];
  [firstName setKey:@"firstName"];
  QEntryElement *nickname = [[QEntryElement alloc] initWithTitle:@"Nickname" Value:student.nickname Placeholder:@"Jack"];
  nickname.key = @"nickname";
  QEntryElement *lastName = [[QEntryElement alloc] initWithTitle:@"Last Name" Value:[student lastName] Placeholder:@"Doe"];
  [lastName setKey:@"lastName"];
  QEntryElement *email = [[QEntryElement alloc] initWithTitle:@"Email" Value:student.email Placeholder:@"address@example.com"];
  email.key = @"email";
  QRadioElement *group = [[QRadioElement alloc] initWithItems:[groups valueForKey:@"name"] selected:-1 title:@"Group"];
  group.values = groups;
  group.selectedValue = student.group;
  [group setKey:@"group"];
  [mainSection addElement:firstName];
  [mainSection addElement:nickname];
  [mainSection addElement:lastName];
  [mainSection addElement:email];
  [mainSection addElement:group];
  [root addSection:mainSection];

  QSection *notesSection = [[QSection alloc] initWithTitle:nil];
  QMultilineElement *notes = [[QMultilineElement alloc] initWithTitle:@"Notes" value:student.notes];
  notes.key = @"notes";
  [notesSection addElement:notes];
  [root addSection:notesSection];

  QSection *controlSection = [[QSection alloc] initWithTitle:@""];
  QButtonElement *saveButton = [[QButtonElement alloc] initWithTitle:@"Save"];
  [saveButton setControllerAction:@"save:"];
  [root addSection:controlSection];
  [controlSection addElement:saveButton];
  return root;
}

- (id)initWithStudent:(Student *)student inSection:(Section *)section {
  NSArray *groups = [[section groups] allObjects];
  self = [self initWithRoot:[TAStudentEditViewController formForStudent:student withGroupOptions:groups]];
  if (self) {
    // Final initialization
    [self setStudent:student];
    [self setSection:section];
  }
  return self;
}

- (void)save:(QButtonElement *)saveButton {
  // Make a copy of the old student data and put it in a dictionary
  NSArray *keys = [[[[self student] entity] attributesByName] allKeys];
  NSDictionary *oldStudentData = [[self student] dictionaryWithValuesForKeys:keys];
  
  // Set the student data to the new values
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [self.root fetchValueIntoObject:dict];
  if (![self student]) {
    self.student = [Student studentWithFirstName:[dict objectForKey:@"firstName"] lastName:[dict objectForKey:@"lastName"] context:self.managedObjectContext];
    self.student.section = self.section;
  }
  else {
    [[self student] setFirstName:[dict objectForKey:@"firstName"]];
    [[self student] setLastName:[dict objectForKey:@"lastName"]];
  }
  self.student.nickname = [dict objectForKey:@"nickname"];
  self.student.email = [dict objectForKey:@"email"];
  self.student.notes = [dict objectForKey:@"notes"];
  self.student.group = [dict objectForKey:@"group"];
  
  [[self navigationController] popViewControllerAnimated:YES];

  if([[self delegate] respondsToSelector:@selector(viewController:savedStudent:withPreviousData:)]) {

    [[self delegate] viewController:self savedStudent:[self student] withPreviousData:oldStudentData];
  }
}

@end
