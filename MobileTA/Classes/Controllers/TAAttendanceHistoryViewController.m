//
//  TAAttendanceHistoryViewController.m
//  MobileTA
//
//  Created by Ted Kalaw on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAAttendanceHistoryViewController.h"

@interface TAAttendanceHistoryViewController ()

@end

@implementation TAAttendanceHistoryViewController {
 NSMutableArray *_tableSections;
}

@synthesize records = _records;

- (id)init {
  self = [self initWithStyle:UITableViewStylePlain];
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = NSLocalizedString(@"Attendance History", nil);
    /*
    self.navigationItem.rightBarButtonItems = @[
                                                self.editButtonItem,
                                                [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                              target:self
                                                                                              action:@selector(addNewSection)]
                                                ];
     */
    //self.tableView.allowsSelectionDuringEditing = YES;
    //    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
    //                                                                               target:self
    //                                                                               action:@selector(addNewSection)];
    //    self.navigationItem.rightBarButtonItem  = addButton;
    
  }
  return self;
}

- (id)initWithSection:(Section *)section {
  self = [super init];
  if (self) {
    self.section = section;
    self.records = [NSMutableArray arrayWithArray:[section.attendanceRecords allObjects]];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  // Load section if they haven't been set
//  NSArray *tempAttendanceRecords;
//    if (!self.records.count) {
//      // Insert current date for testing
//      tempAttendanceRecords = @[
//                            [AttendanceRecord attendanceRecordWithName:@"" date:[NSDate date] context:[self managedObjectContext]],
//                   ];
//      // TODO(srice): Handle errors
//      [self.managedObjectContext save:nil];
//      self.records = tempAttendanceRecords;
//    }
//  
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSections:(NSArray *)attendanceRecords {
  _records = [attendanceRecords copy];
  if ([self isViewLoaded]) {
    [self.tableView reloadData];
  }
}

- (AttendanceRecord *)attendanceRecordAtIndexPath:(NSIndexPath *)indexPath {
  return [[self records] objectAtIndex:[indexPath row]];
}

- (void)editAttendanceRecord:(AttendanceRecord *)attendanceRecord {
  //  Do nothing right now. In the end this will be almost exactly the same as the other stuff
  }

// Is this necessary here? Not sure.
- (void)addAttendanceRecord {
  // For when we put in adding future/past attendance records
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return [[self records] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *attendanceRecordCellId = @"AttendanceRecordCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:attendanceRecordCellId];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:attendanceRecordCellId];
  }
  
  AttendanceRecord *attendanceRecord = [self attendanceRecordAtIndexPath:indexPath];
  cell.textLabel.text = [NSString stringWithFormat:@"%@", attendanceRecord];
  
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
