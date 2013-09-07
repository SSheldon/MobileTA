//
//  TAGridConstants.h
//  MobileTA
//
//  Created by Scott on 3/14/13.
//  Copyright (c) 2013 Steven Sheldon. All rights reserved.
//

#ifndef TAGRIDCONSTANTS_H
#define TAGRIDCONSTANTS_H

#define UNIT_PIXEL_RATIO 32

#define GRID_BOLD_SPACING_UNITS 8

#define ROOM_WIDTH_UNITS 128
#define ROOM_HEIGHT_UNITS 128

#define SEAT_WIDTH_UNITS 4
#define SEAT_HEIGHT_UNITS 4

#define u2p(units) (units) * UNIT_PIXEL_RATIO
#define p2u(pixels) (pixels) / UNIT_PIXEL_RATIO

#define PRESENT_COLOR [UIColor colorWithRed:(99 / 255.0) green:(218 / 255.0) blue:(94 / 255.0) alpha:1]
#define TARDY_COLOR [UIColor colorWithRed:(247 / 255.0) green:(222 / 255.0) blue:(68 / 255.0) alpha:1]
#define ABSENT_COLOR [UIColor colorWithRed:(240 / 255.0) green:(70 / 255.0) blue:(53 / 255.0) alpha:1]
#define PARTICIPATION_COLOR [UIColor colorWithRed:(243 / 255.0) green:(154 / 255.0) blue:0 alpha:1]

#endif
