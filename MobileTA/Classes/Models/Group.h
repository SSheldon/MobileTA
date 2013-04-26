//
//  Group.h
//  MobileTA
//
//  Created by Steven Sheldon on 4/18/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section, Student;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic) int32_t colorRGB;
@property (nonatomic, retain) Section *section;
@property (nonatomic, retain) NSSet *students;

+ (NSArray *)allPossibleColorItems;
+ (Group *)groupWithContext:(NSManagedObjectContext *)context;

- (UIColor *)color;
- (void)setColor:(UIColor *)color;
- (void)setColorRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue;

- (NSArray *)emails;

@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
