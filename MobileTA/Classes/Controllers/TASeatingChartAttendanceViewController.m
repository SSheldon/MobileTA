//
//  TASeatingChartAttendanceViewController.m
//  MobileTA
//
//  Created by Scott on 4/8/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatingChartAttendanceViewController.h"

#import "TAGridConstants.h"

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
  }
  return self;
}

- (void)loadView {
  [super loadView];
  self.view.backgroundColor = [UIColor clearColor];

  _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 10, 180, 60)];
  _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;

  [_segmentedControl setTitleTextAttributes:@{
    UITextAttributeFont: [UIFont boldSystemFontOfSize:20.0f],
  } forState:UIControlStateNormal];

  [_segmentedControl setTitleTextAttributes:@{
    UITextAttributeTextColor: [UIColor blackColor],
  } forState:UIControlStateSelected];

  // Set up segments
  NSArray *labels = @[@"P", @"A", @"T"];
  for (NSUInteger i = 0; i < labels.count; i++) {
    [_segmentedControl insertSegmentWithTitle:labels[i] atIndex:i animated:NO];
    [_segmentedControl setWidth:60.0 forSegmentAtIndex:i];
  }
  _segmentedControl.selectedSegmentIndex = self.studentAttendance.status;
  [self _setSelectedSegmentColor:[self _colorForAttendanceStatus:self.studentAttendance.status]
             forSegmentedControl:_segmentedControl];

  [_segmentedControl addTarget:self
                        action:@selector(changeAttendanceStatus)
              forControlEvents:UIControlEventValueChanged];

  [self.view addSubview:_segmentedControl];

  _segmentedButtons = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 90, 180, 60)];
  _segmentedButtons.segmentedControlStyle = UISegmentedControlStyleBar;

  [_segmentedButtons setTitleTextAttributes:@{
    UITextAttributeFont: [UIFont boldSystemFontOfSize:20.0f],
  } forState:UIControlStateNormal];

  [_segmentedButtons setTitleTextAttributes:@{
     UITextAttributeTextColor: [UIColor blackColor],
  } forState:UIControlStateSelected];

  NSArray *buttons = @[@"-", [self textForValue:[self.studentAttendance participation]], @"+"];
  for (NSUInteger i = 0; i < buttons.count; i++) {
    [_segmentedButtons insertSegmentWithTitle:buttons[i] atIndex:i animated:NO];
    [_segmentedButtons setWidth:60.0 forSegmentAtIndex:i];
  }
  _segmentedButtons.selectedSegmentIndex = 1;
  [self _setSelectedSegmentColor:PARTICIPATION_COLOR forSegmentedControl:_segmentedButtons];

  [_segmentedButtons addTarget:self action:@selector(points) forControlEvents:UIControlEventValueChanged];

  [self.view addSubview:_segmentedButtons];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  // For some reason these won't take on iOS6 if we set them before viewDidAppear;
  // c'mon Apple, make your undocumented API easier to use.
  [self _setSelectedSegmentColor:[self _colorForAttendanceStatus:self.studentAttendance.status]
             forSegmentedControl:_segmentedControl];
  [self _setSelectedSegmentColor:PARTICIPATION_COLOR forSegmentedControl:_segmentedButtons];
}

- (UIColor *)_colorForAttendanceStatus:(StudentAttendanceStatus)status {
  switch (status) {
    case StudentAttendanceStatusAbsent:   return ABSENT_COLOR;
    case StudentAttendanceStatusTardy:    return TARDY_COLOR;
    case StudentAttendanceStatusPresent:  return PRESENT_COLOR;
    default:                              return nil;
  }
}

- (void)_setSelectedSegmentColor:(UIColor *)color forSegmentedControl:(UISegmentedControl *)segmentedControl {
  for (UIButton *segment in segmentedControl.subviews) {
    segment.tintColor = (segment.selected ? color : nil);
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
  // Reset selection so the participation segment stays highlighted
  _segmentedButtons.selectedSegmentIndex = 1;
}

- (void)changeAttendanceStatus {
  StudentAttendanceStatus newStatus = (StudentAttendanceStatus)_segmentedControl.selectedSegmentIndex;
  [self.delegate markStatus:newStatus forStudent:self.student];
  [self _setSelectedSegmentColor:[self _colorForAttendanceStatus:newStatus]
             forSegmentedControl:_segmentedControl];
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
