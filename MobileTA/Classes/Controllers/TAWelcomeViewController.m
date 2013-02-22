//
//  TAWelcomeViewController.m
//  MobileTA
//
//  Created by Yuwei Chen on 2/18/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAWelcomeViewController.h"

@implementation TAWelcomeViewController

@synthesize importButton = _importButton;
@synthesize exportButton = _exportButton;
@synthesize rosterButton = _rosterButton;

-(id)init {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"blackboard.jpeg"]];
    self.view.backgroundColor = background;

    UIImage* image = [UIImage imageNamed:@"logo.png"];
    NSAssert(image, @"image is nil. Check that you added the image to your bundle and that the filename above matches the name of you image.");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(100,100,560,140)];
    [self.view addSubview:imageView];
    
    _importButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [_importButton setFrame:CGRectMake(100,400,160,50)];
    [_importButton setTitle:@"Import" forState:UIControlStateNormal];
    [self.view addSubview:_importButton];
    
    _exportButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [_exportButton setFrame:CGRectMake(300,400,160,50)];
    [_exportButton setTitle:@"Export" forState:UIControlStateNormal];
    [self.view addSubview:_exportButton];
    
    _rosterButton = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [_rosterButton setFrame:CGRectMake(500,400,160,50)];
    [_rosterButton setTitle:@"View Roster" forState:UIControlStateNormal];
    [_rosterButton addTarget:self action:@selector(buttonPressed:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rosterButton];
  }
  return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  return [self init];
}

-(void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(IBAction)buttonPressed:(id)sender {
  // UIButton *button = (UIButton *)sender;
  
  TAStudentsViewController *listViewController = [[TAStudentsViewController alloc] initWithStyle:UITableViewStylePlain];
  [[self navigationController] pushViewController:listViewController animated:YES];
}

@end
