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

@interface TAStudentsViewController : UITableViewController {
  NSMutableArray *_tableSections;
  NSIndexPath *detailedStudentIndex;
}

-(id)initWithStudents:(NSArray *)students;

@property (nonatomic, copy) NSArray *students;
@property (nonatomic, strong)NSIndexPath *detailedStudentIndex;

- (Student *)studentAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathOfStudent:(Student *)student;
- (void)selectStudent:(Student *)student;
- (void)reloadStudents;
- (void)reloadStudent:(Student *)student;
- (void)removeStudent:(Student *)student;

- (UITableViewCell *)createDisplayCellForStudent:(Student *)student;
- (UITableViewCell *)createDetailCellForStudent:(Student *)student;

// Student Details Methods
- (void)showDetailsForStudent:(Student *)student;
- (void)hideStudentDetails;

@end
