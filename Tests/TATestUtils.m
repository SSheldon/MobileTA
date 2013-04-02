//
//  TATestUtils.m
//  MobileTA
//
//  Created by Steven Sheldon on 2/24/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "TATestUtils.h"

#import "AttendanceRecord.h"
#import "Room.h"
#import "Seat.h"
#import "Section.h"
#import "Student.h"
#import "StudentAttendance.h"

@implementation TATestUtils

+ (NSManagedObjectContext *)managedObjectContextForModelsInBundle:(NSBundle *)bundle {
  NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:bundle]];
  NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
  NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
  if (!store) {
    return nil;
  }
  NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
  context.persistentStoreCoordinator = coordinator;
  return context;
}

+ (Section *)sampleSectionWithContext:(NSManagedObjectContext *)context {
  Room *room = [Room roomWithContext:context];

  Seat *seat1 = [Seat seatWithX:1 y:1 context:context];
  seat1.room = room;

  Seat *seat2 = [Seat seatWithX:5 y:5 context:context];
  seat2.room = room;

  Section *section = [Section sectionWithName:@"CS 428" context:context];
  section.room = room;

  Student *student1 = [Student studentWithFirstName:@"Steven" lastName:@"Sheldon" context:context];
  student1.section = section;
  student1.seat = seat1;

  Student *student2 = [Student studentWithFirstName:@"Scott" lastName:@"Rice" context:context];
  student2.nickname = @"Fried";
  student2.section = section;
  student2.seat = seat2;

  NSDate *date = [NSDate dateWithTimeIntervalSince1970:1331467200];
  AttendanceRecord *record = [AttendanceRecord attendanceRecordForName:nil date:date context:context];
  record.section = section;

  StudentAttendance *attendance1 = [StudentAttendance studentAttendanceWithStatus:StudentAttendanceStatusAbsent participation:0 context:context];
  attendance1.student = student1;
  attendance1.attendanceRecord = record;

  StudentAttendance *attendance2 = [StudentAttendance studentAttendanceWithStatus:StudentAttendanceStatusPresent participation:2 context:context];
  attendance2.student = student2;
  attendance2.attendanceRecord = record;

  return section;
}

@end
