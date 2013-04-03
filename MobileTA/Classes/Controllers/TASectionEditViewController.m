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
  QEntryElement *sectionName = [[QEntryElement alloc] initWithTitle:@"Section Name" Value:[section name] Placeholder:@""];
  [sectionName setKey:@"name"];
  [root addSection:mainSection];
  [mainSection addElement:sectionName];
  QSection *controlSection = [[QSection alloc] initWithTitle:@""];
  QButtonElement *saveButton = [[QButtonElement alloc] initWithTitle:@"Save"];
  [saveButton setControllerAction:@"save:"];
  [root addSection:controlSection];
  [controlSection addElement:saveButton];
  return root;
}

- (id)initWithSection:(Section*)section
{
  if([self initWithRoot:[TASectionEditViewController formForSection:section]]) {
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
    Section* newSection = [Section sectionWithName:[dict valueForKey:@"name"] context:[self managedObjectContext]];
    self.section = newSection;
  }
  else {
    [[self section] setName:[dict objectForKey:@"name"]];
  }
  
  [self saveManagedObjectContext];
  [[self navigationController] popViewControllerAnimated:YES];
  
  if([[self delegate] respondsToSelector:@selector(viewController:savedSection:withPreviousData:)]) {
    
    [[self delegate] viewController:self savedSection:[self section] withPreviousData:oldSectionData];
  }
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
