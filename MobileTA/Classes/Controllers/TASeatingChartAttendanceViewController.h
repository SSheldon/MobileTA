//
//  TASeatingChartAttendanceViewController.h
//  MobileTA
//
//  Created by Scott on 4/8/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentAttendance.h"
#import "Student.h"
#import "TABentoButtons.h"
#import "TAStudentsAttendanceViewController.h"

@interface TASeatingChartAttendanceViewController : UIViewController <TABentoButtonsDelegate> {
  UISegmentedControl *_segmentedControl;
}

- (id)initWithStudentAttendance:(StudentAttendance *)studentAttendance student:(Student *)student;

@property (nonatomic,strong)StudentAttendance *studentAttendance;
@property (nonatomic,strong)Student *student;

@property (weak, nonatomic) id<TAStudentsAttendanceDelegate> delegate;

@end
