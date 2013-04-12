//
//  TASeatingChartAttendanceViewController.h
//  MobileTA
//
//  Created by Scott on 4/8/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentAttendance.h"
#import "TABentoButtons.h"

@interface TASeatingChartAttendanceViewController : UIViewController

- (id)initWithStudentAttendance:(StudentAttendance *)studentAttendance;

@property(nonatomic,strong)StudentAttendance *studentAttendance;

@end
