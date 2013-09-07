//
//  TASeatingChartAttendanceViewController.m
//  MobileTA
//
//  Created by Scott on 4/8/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatingChartAttendanceViewController.h"

#import "TAGridConstants.h"

@interface TASeatingChartAttendanceViewController ()

@end

@implementation TASeatingChartAttendanceViewController

@synthesize studentAttendance=_studentAttendance;
@synthesize student=_student;
@synthesize delegate=_delegate;

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
    
    _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 10, 180, 60)];
    // Set up segments
    NSArray *labels = [[NSArray alloc]initWithObjects:@"P", @"A", @"T", nil];
    for (NSUInteger i = 0; i < labels.count; i++) {
      [_segmentedControl insertSegmentWithTitle:labels[i] atIndex:i animated:NO];
      [_segmentedControl setWidth:60.0 forSegmentAtIndex:i];
    }
    
    _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    UIFont *font = [UIFont boldSystemFontOfSize:20.0f];

    // Change selected text color to black
    NSMutableDictionary * selectedTextAttributes = [[NSMutableDictionary alloc] init];
    [selectedTextAttributes setObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
    [selectedTextAttributes setObject:font forKey:UITextAttributeFont];

    [_segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
    
    [_segmentedControl setSelectedSegmentIndex:[studentAttendance status]];
    [_segmentedControl addTarget:self
                          action:@selector(changeAttendanceStatus)
                forControlEvents:UIControlEventValueChanged];
    
    // Add cute little view that Scott made to keep track of participation
    _segmentedButtons = [[TASegmentedButtons alloc] initWithFrame:CGRectMake(10, 90, 180, 60)];
    _segmentedButtons.segmentedControlStyle = UISegmentedControlStyleBar;

    [_segmentedButtons insertSegmentWithTitle:@"-" atIndex:0 animated:NO];
    [_segmentedButtons insertSegmentWithTitle:[self textForValue:[studentAttendance participation]] atIndex:1 animated:NO];
    [_segmentedButtons insertSegmentWithTitle:@"+" atIndex:2 animated:NO];
    [_segmentedButtons setWidth:60.0 forSegmentAtIndex:0];
    [_segmentedButtons setWidth:60.0 forSegmentAtIndex:1];
    [_segmentedButtons setWidth:60.0 forSegmentAtIndex:2];

    _segmentedButtons.momentary = YES;
    [_segmentedButtons setEnabled:NO forSegmentAtIndex:1];
    // Use this to style the center text
    [_segmentedButtons setTitleTextAttributes:selectedTextAttributes forState:UIControlStateNormal];
    [selectedTextAttributes setObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    [_segmentedButtons setTitleTextAttributes:selectedTextAttributes forState:UIControlStateDisabled];

    [_segmentedButtons addTarget:self action:@selector(points) forControlEvents:UIControlEventTouchUpInside];
        
    [v addSubview:_segmentedControl];
    [v addSubview:_segmentedButtons];
    //[v addSubview:bentoBox];
  }
  
  return self;
}

// Changes the color of the button based on which option was selected
- (void)setSelectedSegment {
  StudentAttendanceStatus newStatus = (StudentAttendanceStatus)_segmentedControl.selectedSegmentIndex;
  UIColor *newColor;
  switch (newStatus) {
    case StudentAttendanceStatusAbsent:
      newColor = ABSENT_COLOR;
      break;
    case StudentAttendanceStatusTardy:
      newColor = TARDY_COLOR;
      break;
    case StudentAttendanceStatusPresent:
      newColor = PRESENT_COLOR;
      break;
    default:
      newColor = [UIColor clearColor];
  }
  
  for (NSUInteger i = 0; i < [_segmentedControl.subviews count]; i++) {
    [[_segmentedControl.subviews objectAtIndex:i] setTintColor:nil];
    // If the button is selected,
    if ([[_segmentedControl.subviews objectAtIndex:i] respondsToSelector:@selector(isSelected)] && [[_segmentedControl.subviews objectAtIndex:i]isSelected])
    {
      [[_segmentedControl.subviews objectAtIndex:i] setTintColor:newColor];
    }
  }
}

- (void)points {
  NSInteger action = _segmentedButtons.selectedSegmentIndex;
  if (action == PLUS_ONE) {
    int16_t newValue = [self.delegate changeParticipationBy:1 forStudent:self.student];
    [_segmentedButtons setTitle:[self textForValue:newValue] forSegmentAtIndex:1];
  }
  else if (action == MINUS_ONE) {
    int16_t newValue = [self.delegate changeParticipationBy:-1 forStudent:self.student];
    [_segmentedButtons setTitle:[self textForValue:newValue] forSegmentAtIndex:1];
  }
}

- (void)changeAttendanceStatus {
  StudentAttendanceStatus newStatus = (StudentAttendanceStatus)_segmentedControl.selectedSegmentIndex;
  [self.delegate markStatus:newStatus forStudent:self.student];
  [self setSelectedSegment];
}

- (void)loadView {
  [self setView:[[UIView alloc]init]];
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self setSelectedSegment];
  [[_segmentedButtons.subviews objectAtIndex:1] setTintColor:PARTICIPATION_COLOR];
}

- (NSString *)textForValue:(int16_t)value {
  if (value == 0) {
    return @"+0";
  }
  else {
    return NSStringFromStudentParticipation(value);
  }
}

@end
