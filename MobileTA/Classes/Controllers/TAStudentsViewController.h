//
//  TAStudentTableViewController.h
//  MobileTA
//
//  Created by Steven Sheldon on 1/30/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Section.h"
#import "TAStudentEditViewController.h"

@interface TAStudentsViewController : UITableViewController <TAStudentEditDelegate>

-(id)initWithSection:(Section *)section;
-(id)initWithStudents:(NSArray *)students;

@property (nonatomic, nonatomic) Section *section;
@property (nonatomic, copy) NSArray *students;

@end
