//
//  TAGroupsEditViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 4/25/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAGroupsEditViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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
  
  NSArray *items = @[
                     @[@"Color1", UIColorFromRGB(0xC2C5FF)],
                     @[@"Color2", UIColorFromRGB(0xAA5555)],
                     @[@"Color3", UIColorFromRGB(0xFFBBA8)],
                     @[@"Color4", UIColorFromRGB(0xFFFF7B)],
                     @[@"Color5", UIColorFromRGB(0xFF4258)],
                     @[@"Color6", UIColorFromRGB(0xBF36FF)],
                     @[@"Color7", UIColorFromRGB(0x002E6D)],
                     @[@"Color8", UIColorFromRGB(0x009BDD)],
                     @[@"Color9", UIColorFromRGB(0x006E1A)],
                     @[@"Color10", UIColorFromRGB(0x00A76B)],
                     @[@"Color11", UIColorFromRGB(0xE3DF00)],
                     @[@"Color12", UIColorFromRGB(0xE94A00)],
                     @[@"Color13", UIColorFromRGB(0x00FF11)],
                     @[@"Color14", UIColorFromRGB(0xB86800)],
                     @[@"Color15", UIColorFromRGB(0xFFBD00)],
                     @[@"Color16", UIColorFromRGB(0x4B004F)],
                     @[@"Color17", UIColorFromRGB(0xA200AB)],
                     @[@"Color18", UIColorFromRGB(0xFF0000)],
                     @[@"Color19", UIColorFromRGB(0x547300)],
                     @[@"Color20", UIColorFromRGB(0x00FF99)]
                     ];
  NSUInteger selected = 0;
  if (group.color) {
    NSUInteger counter = 0;
    for (NSArray *item in items) {
      if (group.color == [item objectAtIndex:1]) {
        selected = counter;
        break;
      }
      counter++;
    }
  }
  QColorPickerElement *colorPicker = [[QColorPickerElement alloc] initWithItems:items selected:selected title:@"Color"];
  [colorPicker setKey:@"color"];
  [colorPicker setItems:items];
  [mainSection addElement:colorPicker];
  
  [root addSection:mainSection];
  
  
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
  [[self group] setName:[dict objectForKey:@"name"]];
  [[self group] setColor:[[dict objectForKey:@"color"] objectAtIndex:1]];
  
  [[self navigationController] popViewControllerAnimated:YES];
  
  if([[self delegate] respondsToSelector:@selector(viewController:savedGroup:withPreviousData:)]) {
    
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
