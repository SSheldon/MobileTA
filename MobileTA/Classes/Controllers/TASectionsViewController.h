//
//  TASectionsViewController.h
//  MobileTA
//
//  Created by Scott on 2/25/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Section.h"
#import "TASectionViewController.h"
#import "TASectionEditViewController.h"

@interface TASectionsViewController : UITableViewController <TASectionEditDelegate>

@property (copy, nonatomic) NSArray *sections;

@end
