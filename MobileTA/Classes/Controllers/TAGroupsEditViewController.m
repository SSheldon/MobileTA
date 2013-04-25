//
//  TAGroupsEditViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 4/25/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAGroupsEditViewController.h"

@interface TAGroupsEditViewController ()

@end

@implementation TAGroupsEditViewController

@synthesize group=_group;
@synthesize delegate=_delegate;

+ (QRootElement *)formForGroup:(Group *)group {
  QRootElement *root = [[QRootElement alloc] init];
  [root setGrouped:YES];
  // The only difference between adding a student and editing a student
  // We can tell if this is a new object (aka one that hasn't been saved
  // to Core Data yet) by checking if the managedObjectContext has been set.
  
  if(group) {
    root.title = @"Edit Group";
  }
  else {
    root.title = @"Add Group";
  }
  
  QSection *mainSection = [[QSection alloc] initWithTitle:@""];
  QEntryElement *name = [[QEntryElement alloc] initWithTitle:@"Name" Value:[group name] Placeholder:@"MobileTA"];
  [name setKey:@"name"];
  [mainSection addElement:name];
  [root addSection:mainSection];
  
  //TODO: add colorz
  
  QSection *controlSection = [[QSection alloc] initWithTitle:@""];
  QButtonElement *saveButton = [[QButtonElement alloc] initWithTitle:@"Save"];
  [saveButton setControllerAction:@"save:"];
  [root addSection:controlSection];
  [controlSection addElement:saveButton];
  return root;
}

- (void)save:(QButtonElement *)saveButton {
  // Make a copy of the old student data and put it in a dictionary
  NSArray *keys = [[[[self group] entity] attributesByName] allKeys];
  NSDictionary *oldGroupData = [[self group] dictionaryWithValuesForKeys:keys];
  
  // Set the student data to the new values
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [self.root fetchValueIntoObject:dict];
  if (![self group]) {
    self.group = [Group groupWithContext:self.managedObjectContext];
  }
  else {
    [[self group] setName:[dict objectForKey:@"firstName"]];
  }
  
  [[self navigationController] popViewControllerAnimated:YES];
  
  if([[self delegate] respondsToSelector:@selector(viewController:savedStudent:withPreviousData:)]) {
    
    [[self delegate] viewController:self savedGroup:[self group] withPreviousData:oldGroupData];
  }
}

- (id)initWithGroup:(Group *)group {
  self = [self initWithRoot:[TAGroupsEditViewController formForGroup:group]];
  if (self) {
    // Final initialization
    [self setGroup:group];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
