//
//  TAAssignSeatsViewController.h
//  MobileTA
//
//  Created by Ted Kalaw on 4/1/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAFetchedResultsTableViewController.h"

@class Seat;
@class Section;
@class Student;

@class TAAssignSeatsViewController;

@protocol TAAssignSeatsViewDelegate <NSObject>
@optional
- (void)assignSeatsViewController:(TAAssignSeatsViewController*)controller didSelectStudent:(Student *)student forSeat:(Seat *)seat;
- (void)assignSeatsViewControllerDidCancel:(TAAssignSeatsViewController *)controller;
@end

@interface TAAssignSeatsViewController : TAFetchedResultsTableViewController

-(id)initWithSection:(Section *)section seat:(Seat *)seat;

@property (weak, nonatomic) id<TAAssignSeatsViewDelegate> delegate;
@property (strong, nonatomic) Seat *seat;
@property (strong, nonatomic) Section *section;

@end
