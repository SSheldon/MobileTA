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

@implementation TAGroupsViewController

- (id)initWithSection:(Section *)section {
  self = [self initWithStyle:UITableViewStylePlain];
  if (self) {
    _section = section;
  }
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
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

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.allowsSelectionDuringEditing = YES;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  // Support all orientations
  return YES;
}

#pragma mark TAFetchedResultsTableViewController

- (NSFetchRequest *)fetchRequest {
  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
  fetch.entity = [NSEntityDescription entityForName:@"Group" inManagedObjectContext:self.managedObjectContext];
  fetch.predicate = [NSPredicate predicateWithFormat:@"section = %@", self.section];
  fetch.sortDescriptors = @[
    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],
  ];
  return fetch;
}

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath {
  Group *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [super deleteObjectAtIndexPath:indexPath];
  if ([self.delegate respondsToSelector:@selector(groupsViewController:didRemoveGroup:)]) {
    [self.delegate groupsViewController:self didRemoveGroup:group];
  }
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"GroupsCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  Group *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [[cell textLabel] setText:[group name]];
  [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
  [[cell imageView] setImage:[[group color] imageByDrawingCircleOfColor]];
  return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Group *group = [self.fetchedResultsController objectAtIndexPath:indexPath];
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
  // Inform the delegate
  if ([self.delegate respondsToSelector:@selector(groupsViewController:didUpdateGroup:)]) {
    [self.delegate groupsViewController:self didUpdateGroup:group];
  }
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
