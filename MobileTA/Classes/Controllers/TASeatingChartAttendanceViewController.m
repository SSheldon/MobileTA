//
//  TASeatingChartAttendanceViewController.m
//  MobileTA
//
//  Created by Scott on 4/8/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatingChartAttendanceViewController.h"

@interface TASeatingChartAttendanceViewController ()

@end

@implementation TASeatingChartAttendanceViewController

@synthesize studentAttendance=_studentAttendance;

- (id)initWithStudentAttendance:(StudentAttendance *)studentAttendance {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    // When the view is created, set the student attendance so the right data
    // can be populated
    [self setStudentAttendance:studentAttendance];
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

- (void)loadView {
  [self setView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)]];
  [[self view] setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
