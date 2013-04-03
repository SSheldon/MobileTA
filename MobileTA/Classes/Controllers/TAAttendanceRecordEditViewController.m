//
//  TAAttendanceRecordEditViewController.m
//  MobileTA
//
//  Created by Scott on 3/11/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAAttendanceRecordEditViewController.h"

@interface TAAttendanceRecordEditViewController ()

@end

@implementation TAAttendanceRecordEditViewController

@synthesize attendanceRecord=_attendanceRecord;
@synthesize delegate=_delegate;

+ (QRootElement *)formForAttendanceRecord:(AttendanceRecord *)attendancRecord {
  QRootElement *root = [[QRootElement alloc] init];
  [root setGrouped:YES];
  if(attendancRecord) {
    root.title = @"Edit Attendance Record";
  }
  else {
    root.title = @"Add Attendance Record";
  }
  
  QSection *mainSection = [[QSection alloc] initWithTitle:@""];
  QEntryElement *name = [[QEntryElement alloc] initWithTitle:@"Name" Value:[attendancRecord name] Placeholder:@""];
  [name setKey:@"name"];
  // If we have a previous date, use it. Otherwise, use the current date/time as a default
  NSDate *dateValue = [attendancRecord date];
  if(!dateValue) {
    dateValue = [NSDate date];
  }
  QDateTimeInlineElement *date = [[QDateTimeInlineElement alloc] initWithTitle:@"Date" date:dateValue];
  [date setKey:@"date"];
  [root addSection:mainSection];
  [mainSection addElement:name];
  [mainSection addElement:date];
  QSection *controlSection = [[QSection alloc] initWithTitle:@""];
  QButtonElement *saveButton = [[QButtonElement alloc] initWithTitle:@"Save"];
  [saveButton setControllerAction:@"save:"];
  [root addSection:controlSection];
  [controlSection addElement:saveButton];
  return root;
}
- (id)initWithAttendanceRecord:(AttendanceRecord *)attendanceRecord {
  self = [self initWithRoot:[TAAttendanceRecordEditViewController formForAttendanceRecord:attendanceRecord]];
  if(self) {
    [self setAttendanceRecord:attendanceRecord];
  }
  return self;
}

- (void)save:(QButtonElement *)saveButton {
  // Make a copy of the old student data and put it in a dictionary
  NSArray *keys = [[[[self attendanceRecord] entity] attributesByName] allKeys];
  NSDictionary *oldAttendanceRecordData = [[self attendanceRecord] dictionaryWithValuesForKeys:keys];
  // Set the student data to the new values
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  [self.root fetchValueIntoObject:dict];
  if (![self attendanceRecord]) {
    self.attendanceRecord = [AttendanceRecord attendanceRecordForName:[dict objectForKey:@"name"] date:[dict objectForKey:@"date"] context:self.managedObjectContext];
  }
  else {
    [[self attendanceRecord] setName:[dict objectForKey:@"name"]];
    [[self attendanceRecord] setDate:[dict objectForKey:@"date"]];
  }
  
  [self.navigationController popViewControllerAnimated:YES];
  
  if([[self delegate] respondsToSelector:@selector(viewController:savedAttendanceRecord:withPreviousData:)]) {
    
    [[self delegate] viewController:self savedAttendanceRecord:[self attendanceRecord] withPreviousData:oldAttendanceRecordData];
  }
}

@end
