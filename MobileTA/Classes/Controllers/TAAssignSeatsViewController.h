//
//  TAAssignSeatsViewController.h
//  MobileTA
//
//  Created by Ted Kalaw on 4/1/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsViewController.h"
@class TAAssignSeatsViewController;

@protocol TAAssignSeatsViewDelegate <NSObject>
@optional
- (void)assignSeatsViewController:(TAAssignSeatsViewController*)controller didSelectStudent:(Student *)student forSeat:(Seat *)seat;
- (void)assignSeatsViewControllerDidCancel:(TAAssignSeatsViewController *)controller;
@end

@interface TAAssignSeatsViewController : TAStudentsViewController

-(id)initWithSection:(Section *)section seat:(Seat *)seat;

@property(nonatomic,weak)id<TAAssignSeatsViewDelegate> delegate;
@property (strong, nonatomic) Section *section;
@property (strong, nonatomic) Seat* seat;

@end
