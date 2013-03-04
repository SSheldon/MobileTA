//
//  TASectionViewController.h
//  MobileTA
//
//  Created by Steven Sheldon on 3/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsViewController.h"

#import "TAStudentEditViewController.h"

@interface TASectionViewController : TAStudentsViewController <TAStudentEditDelegate>

- (id)initWithSection:(Section *)section;

@property (strong, nonatomic) Section *section;

@end
