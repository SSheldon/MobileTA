//
//  TASeatingChartViewController.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatingChartViewController.h"

@interface TASeatingChartViewController ()

@end

@implementation TASeatingChartViewController

UIBarButtonItem * addButtonItem;
@synthesize seatingChart=_seatingChart;

- (id)initWithSection:(Section *)section {
  self = [self initWithNibName:nil bundle:nil];
  addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                            target:self
                                                            action:@selector(addSeat)];
  if (self) {
    // Add the edit button to the bar
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
    NSArray *seats = [[[section students] valueForKey:@"seat"] allObjects];
    for(NSUInteger i = 0 ; i < [seats count] ; i++) {
      Seat *seat = [seats objectAtIndex:i];
      [_seatingChart addSeat:seat];
    }
    if (![seats count]) {
      // JUST FOR SHITS AND GIGGLES
      Seat *seat = [NSEntityDescription insertNewObjectForEntityForName:@"Seat" inManagedObjectContext:[self managedObjectContext]];
      seat.x = [NSNumber numberWithInt:4];
      seat.y = [NSNumber numberWithInt:4];
      [_seatingChart addSeat:seat];
      Seat *secondSeat = [NSEntityDescription insertNewObjectForEntityForName:@"Seat" inManagedObjectContext:[self managedObjectContext]];
      secondSeat.x = [NSNumber numberWithInt:8];
      secondSeat.y = [NSNumber numberWithInt:10];
      [_seatingChart addSeat:secondSeat];
    }
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      // Make a scroll view
      _scrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
      [_scrollView setContentSize:[TASeatingChartView roomPixelSize]];
      // Make a seating chart that fills the entire view
      _seatingChart = [[TASeatingChartView alloc] initWithDefaultFrame];
      [[self view] addSubview:_scrollView];
      [_scrollView addSubview:_seatingChart];
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];
  if (editing) {
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, addButtonItem];
  }
  else {
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem];
  }
  [_seatingChart setEditing:editing];
}

- (void)addSeat
{
  Seat *seat = [NSEntityDescription insertNewObjectForEntityForName:@"Seat" inManagedObjectContext:[self managedObjectContext]];
  seat.x = [NSNumber numberWithInt:4];
  seat.y = [NSNumber numberWithInt:4];
  [_seatingChart addSeat:seat];
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
