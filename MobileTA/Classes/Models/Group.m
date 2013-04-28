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
              @[@"Color1", UIColorFromRGB(0xC2C5FF)],
              @[@"Color2", UIColorFromRGB(0xAA5555)],
              @[@"Color3", UIColorFromRGB(0xFFBBA8)],
              @[@"Color4", UIColorFromRGB(0xFFFF7B)],
              @[@"Color5", UIColorFromRGB(0xFF4258)],
              @[@"Color6", UIColorFromRGB(0xBF36FF)],
              @[@"Color7", UIColorFromRGB(0x002E6D)],
              @[@"Color8", UIColorFromRGB(0x009BDD)],
              @[@"Color9", UIColorFromRGB(0x006E1A)],
              @[@"Color10", UIColorFromRGB(0x00A76B)],
              @[@"Color11", UIColorFromRGB(0xE3DF00)],
              @[@"Color12", UIColorFromRGB(0xE94A00)],
              @[@"Color13", UIColorFromRGB(0x00FF11)],
              @[@"Color14", UIColorFromRGB(0xB86800)],
              @[@"Color15", UIColorFromRGB(0xFFBD00)],
              @[@"Color16", UIColorFromRGB(0x4B004F)],
              @[@"Color17", UIColorFromRGB(0xA200AB)],
              @[@"Color18", UIColorFromRGB(0xFF0000)],
              @[@"Color19", UIColorFromRGB(0x547300)],
              @[@"Color20", UIColorFromRGB(0x00FF99)]
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
