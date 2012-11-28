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

@interface DFGWaterReadingsLineGraphIllustrator ()

- (float)reading:(float)value cumulative:(BOOL)cumulative;
- (NSString*)keyForViewX:(CGFloat)x;
@property (nonatomic, strong) NSMutableDictionary* readingsByGraphX;

@end

@implementation DFGWaterReadingsLineGraphIllustrator
{
    float cumulativeTotal;
}

@synthesize backgroundColor;
@synthesize textColorX;
@synthesize textColorY;
@synthesize fontX;
@synthesize fontY;
@synthesize gridLineColor;
@synthesize axesLineColor;
@synthesize axesFont;
@synthesize dateFormatter;
@synthesize graphLineColor;
@synthesize graphFillColor;
@synthesize extractor;

- (BOOL)drawReadings:(NSArray*)readings
           withGauge:(DFGWaterGauge*)gauge
          cumulative:(BOOL)cumulative
           inContext:(CGContextRef*)context
            withRect:(CGRect)rect
{
    // Setup a new dictionary of readings by X graph coordinate.
    [self setReadingsByGraphX:[NSMutableDictionary dictionaryWithCapacity:10]];
    
    if ([readings count] == 0) {
        return NO;
    }
    
    if (cumulative) {
        cumulativeTotal = 0.0;
    }
    
    // Clear context before drawing anything.
    CGContextClearRect(*context, rect);
    
    CGContextSetFillColorWithColor(*context, backgroundColor);
    CGContextFillRect(*context, rect);
    
    // Flip it!
    CGContextTranslateCTM(*context, 0, rect.size.height);
    CGContextScaleCTM(*context, 1, -1);
    
    float minValue = 0.0;
    float maxValue = 0.0;
    
    if (!cumulative) {
        minValue = [[extractor minValue:readings] floatValue];
        maxValue = [[extractor maxValue:readings] floatValue];
    } else {
        minValue = 0.0;
        maxValue = [[extractor sumValue:readings] floatValue];
    }
    
    NSDate* minDate = [extractor minDate:readings];
    NSDate* maxDate = [extractor maxDate:readings];

    NSLog(@"min value: %.2f", minValue);
    NSLog(@"max value: %.2f", maxValue);
    
    NSLog(@"min date: %@", minDate);
    NSLog(@"max date: %@", maxDate);
    
    float lowValue = floor(minValue);
    
    // If the low value is equal to the minimum value, allow an
    // extra foot of low value on the graph so it doesn't bottom
    // out at the bottom of the graph.
    if (minValue != 0.0 && lowValue == minValue) {
        lowValue--;
    }
    
    float highValue = ceil(maxValue);

    // Same here -- don't show the max value at the very top of the
    // graph if the high value is equal to the max.
    if (maxValue != 0.0 && highValue == maxValue) {
        highValue++;
    }
    
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
    CGFloat graphPadding = 12.0;
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
    
    int numLines;
    
    if (yRange == 1) {
        numLines = 5;
    } else if (yRange > 1 && yRange <= 5) {
        numLines = 5;
    } else {
        numLines = yRange;
    }
    
    
    // Equal Y padding on top and bottom, hence the * 2.
    float lineYStep = (rect.size.height - (graphStart.y * 2)) / numLines;

    // Dashed line for grid lines
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(*context, 0.0, dash, 2);
    
    CGFloat lineStartY;
    const char* yLabelString;
    float stepPerLine = (highValue - lowValue) / numLines;
    NSString* readingUnit = [[readings objectAtIndex:0] unit];
                                
    for (int i = 0; i <= numLines; i++) {
        lineStartY = graphStart.y + (lineYStep * i);
        
        // We've already drawn the bottom Y axis line, so skip it,
        // but ensure that we still label each one.
        if (i > 0) {
            CGContextMoveToPoint(*context, graphStart.x, lineStartY);
            CGContextAddLineToPoint(*context, rect.size.width - graphPadding, lineStartY);
        }
        
        // Label each line.
        float axisValue = (float) (lowValue + (stepPerLine * i));
        yLabelString = [[NSString stringWithFormat:@"%.2f %@", axisValue, readingUnit] cStringUsingEncoding:NSUTF8StringEncoding];
        
        // TODO: use the axesFont given
        CGContextSelectFont(*context, "Arial", 12.0, kCGEncodingMacRoman);
        CGContextShowTextAtPoint(*context, graphStart.x, lineStartY, yLabelString, strlen(yLabelString));
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
        
    float valueX = 0;
    float lastX = 0;
    int numSecondsSinceLastReading = 0;
    DFGWaterReading* lastReading = nil;
    
    const char* xLabelString = nil;
    
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
        
        [[self readingsByGraphX] setObject:reading forKey:[self keyForViewX:valueX]];
        
        if (![readingDay isEqualToString:lastDay]) {
            CGContextMoveToPoint(*context, valueX, graphStart.y);
            CGContextAddLineToPoint(*context, valueX, rect.size.height - graphPadding);
            
            // Label each line.
            xLabelString = [[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[reading date]]] cStringUsingEncoding:NSUTF8StringEncoding];
            
            // TODO: use the axesFont given
            CGContextSelectFont(*context, "Arial", 12.0, kCGEncodingMacRoman);
            CGContextShowTextAtPoint(*context, valueX, 0, xLabelString, strlen(xLabelString));
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
    
    float relevantReading;

    for (DFGWaterReading* reading in readings) {
        numSecondsSinceLastReading = [[reading date] timeIntervalSinceDate:[lastReading date]];
        
        if (numSecondsSinceLastReading <= 0) {
            valueX = graphStart.x;
        } else {
            valueX = lastX + (numSecondsSinceLastReading * numPixelsPerSecond);
        }

        relevantReading = [self reading:[[reading value] floatValue] cumulative:cumulative];
        
        // height - ((low value / number of feet in graph)) * (number of pixels in graph)
        valueY = (((relevantReading - lowValue) / yRange) * graphHeight) + graphStart.y;
        
        if (isnan(valueY)) {
            valueY = graphStart.y;
        }
        
        CGContextAddLineToPoint(*context, valueX, valueY);
        
        lastReading = reading;
        lastX = valueX;
        lastY = valueY;
        
        i++;
    }
    
    // Close in the graph before we fill it.
    CGContextAddLineToPoint(*context, lastX, graphStart.y);
    CGContextAddLineToPoint(*context, graphStart.x, graphStart.y);
    CGContextAddLineToPoint(*context, firstX, firstY);
    
    // Fill it.
    CGContextClosePath(*context);
    
    CGContextDrawPath(*context, kCGPathFill);
    
    // Reset the cumulative total.
    if (cumulative) {
        cumulativeTotal = 0.0;
    }
    
    return YES;
}

- (DFGWaterReading*)readingAtPoint:(CGPoint)point
{
    NSString* key = [self keyForViewX:point.x];
    return [[self readingsByGraphX] objectForKey:key];
}

#pragma mark -
#pragma mark Private methods

- (NSString*)keyForViewX:(CGFloat)x
{
    return [NSString stringWithFormat:@"%d", (int) floor(x)];
}

- (float)reading:(float)value cumulative:(BOOL)cumulative
{
    if (cumulative) {
        cumulativeTotal += value;
        return cumulativeTotal;
    }
    
    return value;
}

@end
