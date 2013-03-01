//
//  TAWelcomeViewController.h
//  MobileTA
//
//  Created by Yuwei Chen on 2/18/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAStudentsViewController.h"
#import "TASectionsViewController.h"

@interface TAWelcomeViewController : UIViewController {
}

@property (nonatomic, strong) UIButton *importButton;
@property (nonatomic, strong) UIButton *exportButton;
@property (nonatomic, strong) UIButton *rosterButton;

-(IBAction)buttonPressed:(id)sender;

@end
