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
    
    NSLog(@"min: %@", [extractor minValue:readings]);
    NSLog(@"max: %@", [extractor maxValue:readings]);

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
    CGPoint graphStart = CGPointMake(10.0, 10.0);
    
    // Vertical line
    CGContextMoveToPoint(*context, graphStart.x, graphStart.y);
    CGContextAddLineToPoint(*context, graphStart.x, rect.size.height);
    
    // Horizontal line
    CGContextMoveToPoint(*context, graphStart.x, graphStart.y);
    CGContextAddLineToPoint(*context, rect.size.width, graphStart.y);
    
    CGContextStrokePath(*context);
    
    return YES;
}

@end
