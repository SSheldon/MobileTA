//
//  TASeatingChartView.h
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAGridConstants.h"
#import "Seat.h"
#import "Section.h"
#import "TASeatView.h"

@class AttendanceRecord;
@class StudentAttendance;

@class TASeatingChartView;

@protocol TASeatingChartViewDelegate <NSObject>

@optional
- (void)didAddSeat:(Seat *)seat;
- (void)didSelectSeat:(Seat *)seat;
- (void)didDeleteSeat:(Seat *)seat;
- (void)didMoveSeat:(Seat *)seat toLocation:(CGPoint)location;
- (Seat *)seatForLocation:(CGPoint)location;
//- (void)addParticipationAtSeat:(Seat *)seat;
//- (void)removeParticipationAtSeat:(Seat *)seat;
//- (void)markAbsentAtSeat:(Seat *)seat;
//- (void)markTardyAtSeat:(Seat *)seat;

@end

@interface TASeatingChartView : UIView <UIGestureRecognizerDelegate, TASeatViewDelegate> {
  NSMutableArray *_seatViews;
  Section *_section;
}

+ (CGSize)roomPixelSize;

- (id)initWithDefaultFrame;
- (id)initWithSection:(Section *)section;

- (void)addSeat:(Seat *)seat;
- (void)setStudent:(Student *)student forSeat:(Seat *)seat;

- (id)lastSeat;

- (BOOL)canMoveSeat:(Seat *)seat toPoint:(CGPoint)point;
- (BOOL)canMoveSeatView:(TASeatView *)seatView toPoint:(CGPoint)point;

@property(nonatomic,getter = isEditing)BOOL editing;
@property(nonatomic,strong)AttendanceRecord *attendanceRecord;
@property(nonatomic,weak)id<TASeatingChartViewDelegate> delegate;

@end
