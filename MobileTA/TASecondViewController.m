//
//  TASecondViewController.m
//  MobileTA
//
//  Created by Steven Sheldon on 1/28/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TASecondViewController.h"

@interface TASecondViewController ()

@end

@implementation TASecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = NSLocalizedString(@"Second", @"Second");
    self.tabBarItem.image = [UIImage imageNamed:@"second"];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
