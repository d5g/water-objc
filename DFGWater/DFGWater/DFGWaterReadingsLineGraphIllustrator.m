//
//  DFGWaterReadingsLineGraphIllustrator.m
//  DFGWater
//
//  Created by Brian DeShong on 10/30/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterReadingsLineGraphIllustrator.h"
#import "DFGWaterGauge.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation DFGWaterReadingsLineGraphIllustrator

@synthesize backgroundColor;
@synthesize textColorX;
@synthesize textColorY;
@synthesize titleFont;
@synthesize titleColor;
@synthesize fontX;
@synthesize fontY;

- (BOOL)drawReadings:(NSArray*)readings withGauge:(DFGWaterGauge*)gauge inContext:(CGContextRef*)context withRect:(CGRect)rect
{
    CGContextSetFillColorWithColor(*context, backgroundColor);
    CGContextFillRect(*context, rect);
    
    CGContextSelectFont(*context, "Helvetica", 18.0, kCGEncodingMacRoman);
    CGContextSetFillColorWithColor(*context, titleColor);
    
    // Flip it!
    CGContextTranslateCTM(*context, 0, rect.size.height);
    CGContextScaleCTM(*context, 1, -1);
    
    const char* title = [[gauge name] cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextShowTextAtPoint(*context, 100.0, rect.size.height - 50, title, strlen(title));
    
    return YES;
}

@end
