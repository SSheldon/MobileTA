//
//  TASeatingChartViewController.m
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASeatingChartViewController.h"

#import "Room.h"

@interface TASeatingChartViewController ()

@end

@implementation TASeatingChartViewController

@synthesize seatingChart=_seatingChart;

- (id)initWithSection:(Section *)section {
  self = [self initWithNibName:nil bundle:nil];
  addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                            target:self
                                                            action:@selector(addSeat)];
  if (self) {
    // Add the edit button to the bar
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
#if DEBUG
    if (section && !section.room.seats.count) {
      if (!section.room) {
        section.room = [Room roomWithContext:self.managedObjectContext];
      }
      // JUST FOR SHITS AND GIGGLES
      [section.room addSeatsObject:[Seat seatWithX:4 y:4 context:self.managedObjectContext]];
      [section.room addSeatsObject:[Seat seatWithX:10 y:8 context:self.managedObjectContext]];
      [self.managedObjectContext save:nil];
    }
#endif
    for (Seat *seat in section.room.seats) {
      [_seatingChart addSeat:seat];
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
      // The highest they can zoom is double the size
      [_scrollView setMaximumZoomScale:2.0];
      // The lowest they can zoom is 1/4 the size
      [_scrollView setMinimumZoomScale:0.4];
      [_scrollView setDelegate:self];
      // Make a seating chart that fills the entire view
      _seatingChart = [[TASeatingChartView alloc] initWithDefaultFrame];
      [_seatingChart setDelegate:self];
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
  Seat *lastSeat = [_seatingChart lastSeat];
  if (!lastSeat) {
    seat.x = 0;
    seat.y = 0;
  }
  else if (lastSeat.x <= 16) {
    seat.x = lastSeat.x + 4;
    seat.y = lastSeat.y;
  }
  else {
    seat.x = 0;
    seat.y = lastSeat.y + 4;
  }
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

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return _seatingChart;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
  
}

#pragma mark TASeatingChartView

- (void)didDeleteSeat:(Seat *)seat {
  NSLog(@"Deleting seat");
}

@end
