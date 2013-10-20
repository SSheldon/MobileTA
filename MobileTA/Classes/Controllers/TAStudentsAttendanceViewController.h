//
//  TAStudentsAttendanceViewController.h
//  MobileTA
//
//  Created by Steven Sheldon on 4/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "TAFetchedResultsTableViewController.h"
#import "TAStudentDetailCell.h"
#import "StudentAttendance.h"

@class Section;

@class TAStudentsAttendanceViewController;

@protocol TAStudentsAttendanceDelegate <NSObject>

- (StudentAttendanceStatus)statusForStudent:(Student *)student;
- (int16_t)particpationForStudent:(Student *)student;

- (StudentAttendanceStatus)markStatus:(StudentAttendanceStatus)status forStudent:(Student *)student;
- (int16_t)changeParticipationBy:(int16_t)value forStudent:(Student *)student;

@optional
- (void)viewController:(TAStudentsAttendanceViewController *)controller didSelectStudentToEdit:(Student *)student;
- (void)viewController:(TAStudentsAttendanceViewController *)controller didRemoveStudent:(Student *)student;

@end

@interface TAStudentsAttendanceViewController : TAFetchedResultsTableViewController <TAStudentDetailDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) Section *section;
@property (weak, nonatomic) id<TAStudentsAttendanceDelegate> delegate;

- (void)reloadStudent:(Student *)student;

@end
