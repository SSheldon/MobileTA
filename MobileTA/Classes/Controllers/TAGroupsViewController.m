//
//  TAGroupsViewController.m
//  MobileTA
//
//  Created by Scott on 4/22/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAGroupsViewController.h"
#import "Section.h"
#import "Group.h"

@interface TAGroupsViewController ()

@end

@implementation TAGroupsViewController


- (id)initWithSection:(Section *)section {
  self = [self initWithStyle:UITableViewStylePlain];
  if (self) {
    _section = section;
    _groups = [[section groups] allObjects];
    [[self tableView] setAllowsSelectionDuringEditing:YES];
  }
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
      self.title = NSLocalizedString(@"Groups", nil);
      self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                      target:self
                                                      action:@selector(cancel)];
      self.navigationItem.rightBarButtonItems = @[
        self.editButtonItem,
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(addNewGroup)]
      ];
    }
    return self;
}

- (void)cancel {
  if ([self.delegate respondsToSelector:@selector(attendanceHistoryViewControllerDidCancel:)]) {
    [self.delegate groupsViewControllerDidCancel:self];
  }
}

- (void)editGroup:(Group *)group {
  TAGroupsEditViewController *evc = [[TAGroupsEditViewController alloc] initWithGroup:group];
  [evc setDelegate:self];
  [[self navigationController] pushViewController:evc animated:YES];
}

- (void)addNewGroup {
  [self editGroup:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [_groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"GroupsCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  Group *group = [_groups objectAtIndex:indexPath.row];
  [[cell textLabel] setText:[group name]];
  
  return cell;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(editingStyle == UITableViewCellEditingStyleDelete) {
    // Remove the group at that index from the database
    Group *group = [_groups objectAtIndex:indexPath.row];
    [[self managedObjectContext] deleteObject:group];
    [self saveManagedObjectContext];
    // Remove group from the Groups array
    NSMutableArray *mutableGroups = [[self groups] mutableCopy];
    [mutableGroups removeObject:group];
    _groups = mutableGroups;
    [[self tableView] reloadData];
  }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Group *group = [_groups objectAtIndex:indexPath.row];
  if (self.editing) {
    [self editGroup:group];
  }
  else {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setToRecipients:[group emails]];
    mailController.mailComposeDelegate = self;
    mailController.modalPresentationStyle = UIModalPresentationFormSheet;
    mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:mailController animated:YES completion:nil];
  }
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark TAGroupEditDelegate

- (void)viewController:(TAGroupsEditViewController *)viewController savedGroup:(Group *)group withPreviousData:(NSDictionary *)oldData {
  [group setSection:[self section]];
  [self saveManagedObjectContext];
  if(!oldData) {
    _groups = [_groups arrayByAddingObject:group];
  }
  [[self tableView] reloadData];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
