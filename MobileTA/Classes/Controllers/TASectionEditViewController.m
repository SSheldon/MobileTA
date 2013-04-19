//
//  TASectionEditViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 3/6/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASectionEditViewController.h"

@implementation TASectionEditViewController

@synthesize section = _section;
@synthesize delegate = _delegate;

+ (QRootElement *)formForSection:(Section*)section
{
  QRootElement *root = [[QRootElement alloc] init];
  [root setGrouped:YES];
 
  if(section) {
    root.title = @"Edit Section";
  }
  else {
    root.title = @"Add Section";
  }
  
  QSection *mainSection = [[QSection alloc] initWithTitle:@""];
  QEntryElement *courseName = [[QEntryElement alloc] initWithTitle:@"Course Name" Value:[section course] Placeholder:@""];
  QEntryElement *sectionName = [[QEntryElement alloc] initWithTitle:@"Section Name" Value:[section name] Placeholder:@""];
  [courseName setKey:@"courseName"];
  [sectionName setKey:@"sectionName"];
  [root addSection:mainSection];
  [mainSection addElement:courseName];
  [mainSection addElement:sectionName];
  QSection *controlSection = [[QSection alloc] initWithTitle:@""];
  QButtonElement *saveButton = [[QButtonElement alloc] initWithTitle:@"Save"];
  [saveButton setControllerAction:@"save:"];
  [root addSection:controlSection];
  [controlSection addElement:saveButton];
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
  NSArray *keys = [[[[self section] entity] attributesByName] allKeys];
  NSDictionary *oldSectionData = [[self section] dictionaryWithValuesForKeys:keys];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [self.root fetchValueIntoObject:dict];
  
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
