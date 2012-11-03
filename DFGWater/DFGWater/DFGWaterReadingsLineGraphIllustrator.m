//
//  DFGWaterReadingsLineGraphIllustrator.m
//  DFGWater
//
//  Created by Brian DeShong on 10/30/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterReadingsLineGraphIllustrator.h"
#import "DFGWaterGauge.h"
#import "DFGWaterReadingsDataExtractor.h"
#import "DFGWaterReading.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation DFGWaterReadingsLineGraphIllustrator

@synthesize backgroundColor;
@synthesize textColorX;
@synthesize textColorY;
@synthesize fontX;
@synthesize fontY;
@synthesize gridLineColor;
@synthesize axesLineColor;
@synthesize extractor;

- (BOOL)drawReadings:(NSArray*)readings withGauge:(DFGWaterGauge*)gauge inContext:(CGContextRef*)context withRect:(CGRect)rect
{
    if ([readings count] == 0) {
        return NO;
    }
    
    CGContextSetFillColorWithColor(*context, backgroundColor);
    CGContextFillRect(*context, rect);
    
    // Flip it!
    CGContextTranslateCTM(*context, 0, rect.size.height);
    CGContextScaleCTM(*context, 1, -1);
    
    float minValue = [[extractor minValue:readings] floatValue];
    float maxValue = [[extractor maxValue:readings] floatValue];
    NSDate* minDate = [extractor minDate:readings];
    NSDate* maxDate = [extractor maxDate:readings];

    NSLog(@"min value: %.2f", minValue);
    NSLog(@"max value: %.2f", maxValue);
    
    NSLog(@"min date: %@", minDate);
    NSLog(@"max date: %@", maxDate);
    
    float lowValue = floor(minValue);
    float highValue = ceil(maxValue);

    // Not our job to draw the title
    //CGContextSelectFont(*context, "Helvetica", 18.0, kCGEncodingMacRoman);
    //CGContextSetFillColorWithColor(*context, titleColor);
    //const char* title = [[gauge name] cStringUsingEncoding:NSASCIIStringEncoding];
    //CGContextShowTextAtPoint(*context, 100.0, rect.size.height - 50, title, strlen(title));

    //
    // Left and bottom graph axes.
    //
    
    CGContextSetFillColorWithColor(*context, axesLineColor);
    CGContextSetStrokeColorWithColor(*context, axesLineColor);
    CGContextSetLineWidth(*context, 0.8);
    CGContextBeginPath(*context);
    CGFloat graphPadding = 10.0;
    CGPoint graphStart = CGPointMake(graphPadding, graphPadding);
    
    // Left vertical line
    CGContextMoveToPoint(*context, graphStart.x, graphStart.y);
    CGContextAddLineToPoint(*context, graphStart.x, rect.size.height - graphStart.y);
    
    // Horizontal line
    CGContextMoveToPoint(*context, graphStart.x, graphStart.y);
    CGContextAddLineToPoint(*context, rect.size.width - graphPadding, graphStart.y);
    
    // Right vertical line
    CGContextMoveToPoint(*context, graphStart.x + rect.size.width - (graphPadding * 2), graphStart.y);
    CGContextAddLineToPoint(*context, graphStart.x + rect.size.width - (graphPadding * 2), rect.size.height - graphStart.y);
    
    //
    // Horizontal grid lines
    //
    
    int numLines = 5;
    // Equal Y padding on top and bottom, hence the * 2.
    float lineYStep = (rect.size.height - (graphStart.y * 2)) / numLines;

    // Dashed line for grid lines
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(*context, 0.0, dash, 2);
    
    CGFloat lineStartY;

    for (int i = 1; i <= numLines; i++) {
        lineStartY = graphStart.y + (lineYStep * i);
        CGContextMoveToPoint(*context, graphStart.x, lineStartY);
        CGContextAddLineToPoint(*context, rect.size.width - graphPadding, lineStartY);
    }
    
    //
    // Vertical grid lines
    //
    
    // Get the number of days represented
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSString* lastDay = nil;
    NSMutableArray* days = [[NSMutableArray alloc] initWithCapacity:5];
    NSString* readingDay = nil;
    
    for (DFGWaterReading* reading in readings) {
        readingDay = [dateFormatter stringFromDate:[reading date]];
        
        if (![readingDay isEqualToString:lastDay]) {
            [days addObject:readingDay];
            lastDay = readingDay;
        }
    }

    // Draw the vertical grid lines.
    NSUInteger numDays = [days count];
    CGFloat lineStartX;
    CGFloat lineXStep = (rect.size.width - (graphPadding * 2)) / numDays;
    
    for (int i = 1; i < numDays; i++) {
        lineStartX = graphStart.x + (lineXStep * i);
        CGContextMoveToPoint(*context, lineStartX, graphStart.y);
        CGContextAddLineToPoint(*context, lineStartX, rect.size.height - graphPadding);
    }
    
    for (DFGWaterReading* reading in readings) {
        CGContextMoveToPoint(*context, graphStart.x, graphStart.y);
        NSLog(@"height = %@", [reading value]);
    }
    
    CGContextStrokePath(*context);
    
    return YES;
}

@end
