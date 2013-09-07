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

#define PRESENT_COLOR [UIColor greenColor]
#define TARDY_COLOR [UIColor yellowColor]
#define ABSENT_COLOR [UIColor redColor]
#define PARTICIPATION_COLOR [UIColor orangeColor]

#endif
