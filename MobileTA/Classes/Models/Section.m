//
//  Section.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Section.h"
#import "AttendanceRecord.h"
#import "Room.h"
#import "Student.h"


@implementation Section

@dynamic name;
@dynamic course;
@dynamic attendanceRecords;
@dynamic room;
@dynamic students;

+ (Section *)sectionWithName:(NSString *)name context:(NSManagedObjectContext *)context {
  Section *section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:context];
  
  section.name = name;
  
  return section;
}

+ (NSArray *)fetchSectionsInContext:(NSManagedObjectContext *)context {
  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
  fetch.entity = [NSEntityDescription entityForName:@"Section" inManagedObjectContext:context];
  // TODO(ssheldon): Handle errors
  return [context executeFetchRequest:fetch error:nil];
}

- (NSString *)description {
  if(self.room) {
    return [NSString stringWithFormat:@"%@ (%@)", self.name,self.room.name];
  }
  else {
    return [NSString stringWithFormat:@"%@", self.name];
  }
}

@end
