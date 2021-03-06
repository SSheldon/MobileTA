//
//  TAGroupsEditViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 4/25/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAGroupsEditViewController.h"

@implementation TAGroupsEditViewController

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
  
  NSArray *items = [Group allPossibleColorItems];
  NSUInteger selected = 0;
  if (group.color) {
    NSUInteger counter = 0;
    for (NSArray *item in items) {
      if ([group.color isEqual:[item objectAtIndex:1]]) {
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
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [self.root fetchValueIntoObject:dict];

  // Validate that required fields have been set
  if (![[dict objectForKey:@"name"] length]) {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"A group name is required."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    return;
  }

  // Make a copy of the old student data and put it in a dictionary
  NSArray *keys = [[[[self group] entity] attributesByName] allKeys];
  NSDictionary *oldGroupData = [[self group] dictionaryWithValuesForKeys:keys];
  
  // Set the student data to the new values
  if (![self group]) {
    self.group = [Group groupWithContext:self.managedObjectContext];
  }
  [[self group] setName:[dict objectForKey:@"name"]];
  NSArray *items = [Group allPossibleColorItems];
  NSUInteger colorIndex = [[dict objectForKey:@"color"] intValue];
  [[self group] setColor:[[items objectAtIndex:colorIndex] objectAtIndex:1]];
  
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

@end
