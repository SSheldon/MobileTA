//
//  Group.m
//  MobileTA
//
//  Created by Steven Sheldon on 4/18/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import "Group.h"
#import "Section.h"
#import "Student.h"

@implementation Group

@dynamic name;
@dynamic colorRGB;
@dynamic section;
@dynamic students;

#define UIColorFromRGB(rgb) [UIColor colorWithRed:(((rgb & 0xFF0000) >> 16) / 255.0)\
                                            green:(((rgb & 0xFF00) >> 8) / 255.0)\
                                             blue:((rgb & 0xFF) / 255.0)\
                                            alpha:1]

+ (Group *)groupWithContext:(NSManagedObjectContext *)context {
  return [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:context];
}

+ (NSArray *)allPossibleColorItems {
  static NSArray *items = nil;
  if (items == nil) {
    items = @[
      @[@"Purple", UIColorFromRGB(0xA020F0)],
      @[@"Cerulean", UIColorFromRGB(0x009BDD)],
      @[@"Nighttime", UIColorFromRGB(0x002E6D)],
      @[@"Leaf Green", UIColorFromRGB(0x006E1A)],
      @[@"Mint Green", UIColorFromRGB(0x00FF99)],
      @[@"Sand", UIColorFromRGB(0xFFFF7B)],
      @[@"Goldenrod", UIColorFromRGB(0xE3DF00)],
      @[@"Orange Tang", UIColorFromRGB(0xFFBD00)],
      @[@"Orangered", UIColorFromRGB(0xFF4258)],
      @[@"Pink", UIColorFromRGB(0xFF1493)],
      @[@"Princess Peach", UIColorFromRGB(0xFFBBA8)],
      @[@"Fried Rice", UIColorFromRGB(0xB86800)],
    ];
  }
  return items;
}

- (UIColor *)color {
  int32_t rgb = self.colorRGB;
  return UIColorFromRGB(rgb);
}

- (void)setColor:(UIColor *)color {
  CGFloat r, g, b;
  [color getRed:&r green:&g blue:&b alpha:NULL];
  [self setColorRed:(uint8_t)(r * 0xFF)
              green:(uint8_t)(g * 0xFF)
               blue:(uint8_t)(b * 0xFF)];
}

- (void)setColorRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue {
  self.colorRGB = (red << 16) | (green << 8) | blue;
}

- (NSArray *)emails {
  return [[self.students valueForKey:@"email"] allObjects];
}

@end
