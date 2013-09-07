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
#import "TAStudentsAttendanceViewController.h"

#define MINUS_ONE 0
#define PLUS_ONE 2

@interface TASeatingChartAttendanceViewController : UIViewController {
  UISegmentedControl *_segmentedControl;
  UISegmentedControl *_segmentedButtons;
}

- (id)initWithStudentAttendance:(StudentAttendance *)studentAttendance student:(Student *)student;

@property (nonatomic,strong)StudentAttendance *studentAttendance;
@property (nonatomic,strong)Student *student;

@property (weak, nonatomic) id<TAStudentsAttendanceDelegate> delegate;

@end
