//
//  Room.m
//  MobileTA
//
//  Created by Scott on 2/4/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Room.h"
#import "Seat.h"
#import "Section.h"


@implementation Room

@dynamic name;
@dynamic seats;
@dynamic sections;

+ (Room *)roomWithContext:(NSManagedObjectContext *)context {
  return [NSEntityDescription insertNewObjectForEntityForName:@"Room" inManagedObjectContext:context];
}

@end
