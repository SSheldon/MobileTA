//
//  TASectionEditViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 3/6/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASectionEditViewController.h"

@implementation TASectionEditViewController

+ (QRootElement *)formForSection:(Section*)section {
  QRootElement *root = [[QRootElement alloc] init];
  [root setGrouped:YES];
 
  if(section) {
    root.title = @"Edit Section";
  }
  else {
    root.title = @"Add Section";
  }
  
  QEntryElement *courseName = [[QEntryElement alloc] initWithTitle:@"Course Name" Value:[section course] Placeholder:@"Math 101"];
  [courseName setKey:@"courseName"];
  QEntryElement *sectionName = [[QEntryElement alloc] initWithTitle:@"Section Name" Value:[section name] Placeholder:@"Discussion 1"];
  [sectionName setKey:@"sectionName"];

  QSection *mainSection = [[QSection alloc] initWithTitle:nil];
  [mainSection addElement:courseName];
  [mainSection addElement:sectionName];
  [root addSection:mainSection];

  QButtonElement *saveButton = [[QButtonElement alloc] initWithTitle:@"Save"];
  [saveButton setControllerAction:@"save:"];
  QSection *controlSection = [[QSection alloc] initWithTitle:nil];
  [controlSection addElement:saveButton];
  [root addSection:controlSection];
  return root;
}

- (id)initWithSection:(Section *)section {
  self = [self initWithRoot:[TASectionEditViewController formForSection:section]];
  if (self) {
    [self setSection:section];
  }
  return self;
}

- (void)save:(QButtonElement *)saveButton {
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [self.root fetchValueIntoObject:dict];

  // Validate that required fields have been set
  if (![[dict objectForKey:@"courseName"] length]) {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"A course name is required."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    return;
  }

  NSArray *keys = [[[[self section] entity] attributesByName] allKeys];
  NSDictionary *oldSectionData = [[self section] dictionaryWithValuesForKeys:keys];
  
  if (![self section]) {
    Section* newSection = [Section sectionWithName:[dict valueForKey:@"sectionName"] course:[dict valueForKey:@"courseName"] context:[self managedObjectContext]];
    self.section = newSection;
  }
  else {
    [[self section] setName:[dict objectForKey:@"sectionName"]];
    [[self section] setCourse:[dict valueForKey:@"courseName"]];
  }
  
  [[self navigationController] popViewControllerAnimated:YES];
  
  if([[self delegate] respondsToSelector:@selector(viewController:savedSection:withPreviousData:)]) {
    
    [[self delegate] viewController:self savedSection:[self section] withPreviousData:oldSectionData];
  }
}

@end
