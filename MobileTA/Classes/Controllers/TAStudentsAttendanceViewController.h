//
//  TAStudentsAttendanceViewController.h
//  MobileTA
//
//  Created by Steven Sheldon on 4/7/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TAStudentsViewController.h"
#import "TAStudentDetailCell.h"
#import "StudentAttendance.h"

@class TAStudentsAttendanceViewController;

@protocol TAStudentsAttendanceDelegate <NSObject>

- (StudentAttendanceStatus)statusForStudent:(Student *)student;
- (int16_t)particpationForStudent:(Student *)student;

- (StudentAttendanceStatus)markStatus:(StudentAttendanceStatus)status forStudent:(Student *)student;
- (int16_t)changeParticipationBy:(int16_t)value forStudent:(Student *)student;

@optional
- (void)viewController:(TAStudentsAttendanceViewController *)controller didSelectStudentToEdit:(Student *)student;

@end

@interface TAStudentsAttendanceViewController : TAStudentsViewController <TAStudentDetailDelegate>

@property (weak, nonatomic) id<TAStudentsAttendanceDelegate> delegate;

// Override these methods in subclasses instead of setting a delegate
- (StudentAttendanceStatus)statusForStudent:(Student *)student;
- (int16_t)particpationForStudent:(Student *)student;
- (StudentAttendanceStatus)markStatus:(StudentAttendanceStatus)status forStudent:(Student *)student;
- (int16_t)changeParticipationBy:(int16_t)value forStudent:(Student *)student;
- (void)selectStudentToEdit:(Student *)student;

@end
