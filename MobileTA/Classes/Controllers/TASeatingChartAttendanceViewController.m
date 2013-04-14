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
@synthesize student=_student;
@synthesize delegate=_delegate;


+ (UIColor *)colorForAttendanceStatus:(StudentAttendanceStatus)status {
  switch (status) {
    case StudentAttendanceStatusAbsent:   return [UIColor redColor];
    case StudentAttendanceStatusTardy:    return [UIColor yellowColor];
    case StudentAttendanceStatusPresent:  return [UIColor greenColor];
    default:                              return [UIColor clearColor];
  }
}
// When the view is created, set the student attendance so the right data
// can be populated
- (id)initWithStudentAttendance:(StudentAttendance *)studentAttendance student:(Student *)student {
  self = [self initWithNibName:nil bundle:nil];
  if (self) {
    [self setStudentAttendance:studentAttendance];
    [self setStudent:student];
    // Do work son
    UIView *v = [self view];
    [v setBackgroundColor:[UIColor clearColor]];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 10, 200, 50)];
    // Set up segments
    NSArray *labels = [[NSArray alloc]initWithObjects:@"P", @"A", @"T", nil];
    for (int i=0; i<labels.count; i++) {
      [_segmentedControl insertSegmentWithTitle:labels[i] atIndex:i animated:NO];
      [_segmentedControl setWidth:60.0 forSegmentAtIndex:i];
    }
    
    _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    // Change selected text color to black
    NSMutableDictionary * textAttributes = [[NSMutableDictionary alloc] init];
    [textAttributes setObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
    [_segmentedControl setTitleTextAttributes:textAttributes forState:UIControlStateSelected];
    
    [_segmentedControl setSelectedSegmentIndex:[studentAttendance status]];
    [_segmentedControl addTarget:self
                          action:@selector(changeAttendanceStatus)
                forControlEvents:UIControlEventValueChanged];

    [v addSubview:_segmentedControl];

  }
  return self;
}

// Changes the color of the button based on which option was selected
- (void)setSelectedSegmentShadowToColor:(UIColor *)newColor {
  for (int i=0; i<[_segmentedControl.subviews count]; i++) {
    [[_segmentedControl.subviews objectAtIndex:i] setTintColor:nil];
    // If the button is selected,
    if ([[_segmentedControl.subviews objectAtIndex:i] respondsToSelector:@selector(isSelected)] && [[_segmentedControl.subviews objectAtIndex:i]isSelected])
    {
      [[_segmentedControl.subviews objectAtIndex:i] setTintColor:newColor];
    }
  }
}

- (void)selectSelectedSegment {
  StudentAttendanceStatus newStatus = (StudentAttendanceStatus)_segmentedControl.selectedSegmentIndex;
  UIColor *newColor;
  switch (newStatus) {
    case StudentAttendanceStatusAbsent:
      newColor = [UIColor redColor];
      break;
    case StudentAttendanceStatusTardy:
      newColor = [UIColor yellowColor];
      break;
    case StudentAttendanceStatusPresent:
      newColor = [UIColor greenColor];
      break;
    default:
      newColor = [UIColor clearColor];
  }
  [self setSelectedSegmentShadowToColor:newColor];
}

- (void)changeAttendanceStatus {
  StudentAttendanceStatus newStatus = (StudentAttendanceStatus)_segmentedControl.selectedSegmentIndex;
  [self.delegate markStatus:newStatus forStudent:self.student];
  [self selectSelectedSegment];
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
  [self setView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)]];
  [[self view] setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self selectSelectedSegment];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
