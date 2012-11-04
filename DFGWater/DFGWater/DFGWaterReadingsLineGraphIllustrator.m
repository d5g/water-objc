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
@synthesize graphLineColor;
@synthesize graphFillColor;
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
    float yRange = highValue - lowValue;

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
    //CGContextBeginPath(*context);
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
    // Draw the vertical grid lines.
    //
    NSString* lastDay = nil;
    NSString* readingDay = nil;
    
    NSDate* firstDate = [[readings objectAtIndex:0] date];
    NSDate* lastDate = [[readings lastObject] date];
    
    int numSecondsRange = [lastDate timeIntervalSinceDate:firstDate];
    float numPixelsPerSecond = (rect.size.width - (graphPadding * 2)) / numSecondsRange;
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    NSMutableArray* days = [[NSMutableArray alloc] initWithCapacity:5];

    float valueX = 0;
    float lastX = 0;
    int numSecondsSinceLastReading = 0;
    DFGWaterReading* lastReading = nil;
    
    for (DFGWaterReading* reading in readings) {
        // After drawing this point, determine if the day changed.  If it has, draw
        // the vertical grid line as well.
        numSecondsSinceLastReading = [[reading date] timeIntervalSinceDate:[lastReading date]];

        readingDay = [dateFormatter stringFromDate:[reading date]];
        
        if (numSecondsSinceLastReading < 0) {
            valueX = graphStart.x;
        } else {
            valueX = lastX + (numSecondsSinceLastReading * numPixelsPerSecond);
        }
        
        if (![readingDay isEqualToString:lastDay]) {
            CGContextMoveToPoint(*context, valueX, graphStart.y);
            CGContextAddLineToPoint(*context, valueX, rect.size.height - graphPadding);
        }
        
        lastDay = readingDay;
        lastX = valueX;
        lastReading = reading;
    }
    
    CGContextClosePath(*context);
    CGContextStrokePath(*context);
        
    //
    // Draw the points.
    //
    
    int i = 0;
    valueX = 0;
    float valueY = 0;
    float firstX;
    float firstY;
    lastX = 0.0;
    float lastY;
    numSecondsSinceLastReading = 0;
    
    lastReading = nil;

    CGContextBeginPath(*context);
    
    // Get the number of days represented
    CGFloat graphHeight = rect.size.height - (graphPadding * 2);

    // Remove dash.
    CGContextSetLineDash(*context, 0, NULL, 0);
    
    // Begin the graph path
    CGContextSetLineWidth(*context, 2.0);
    
    CGContextSetStrokeColorWithColor(*context, graphLineColor);
    
    // TODO: start at the appropriate Y for reading 0.
    valueY = graphStart.y + (([[[readings objectAtIndex:0] value] floatValue] - lowValue) * graphHeight);

    // Hang on to the starting points so we can come back to them
    // when filling the graph.
    firstX = graphStart.x;
    firstY = valueY;
    
    // Set the fill color.
    CGContextSetFillColorWithColor(*context, graphFillColor);
    
    CGContextMoveToPoint(*context, graphStart.x, valueY);

    for (DFGWaterReading* reading in readings) {
        numSecondsSinceLastReading = [[reading date] timeIntervalSinceDate:[lastReading date]];
        
        if (numSecondsSinceLastReading < 0) {
            valueX = graphStart.x;
        } else {
            valueX = lastX + (numSecondsSinceLastReading * numPixelsPerSecond);
        }

        // height - ((low value / number of feet in graph)) * (number of pixels in graph)
        valueY = (([[reading value] floatValue] - lowValue) / yRange) * graphHeight;
        
        CGContextAddLineToPoint(*context, valueX, valueY);
        
        lastReading = reading;
        lastX = valueX;
        lastY = valueY;
        NSLog(@"reading = %@", reading);
        
        i++;
    }
    
    // Close in the graph before we fill it.
    CGContextAddLineToPoint(*context, lastX, graphStart.y);
    CGContextAddLineToPoint(*context, graphStart.x, graphStart.y);
    CGContextAddLineToPoint(*context, firstX, firstY);
    
    // Fill it.
    CGContextClosePath(*context);
    
    CGContextDrawPath(*context, kCGPathFill);
    
    return YES;
}

@end
