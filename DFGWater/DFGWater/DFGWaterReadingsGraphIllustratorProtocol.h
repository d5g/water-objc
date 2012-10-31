//
//  DFGWaterReadingsGraphIllustrator.h
//  DFGWater
//
//  Created by Brian DeShong on 10/30/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class DFGWaterGauge;

@protocol DFGWaterReadingsGraphIllustratorProtocol <NSObject>

- (BOOL)drawReadings:(NSArray*)readings withGauge:(DFGWaterGauge*)gauge inContext:(CGContextRef*)context withRect:(CGRect)rect;

@property (nonatomic, assign) CGColorRef backgroundColor;
@property (nonatomic, assign) CGColorRef textColorX;
@property (nonatomic, assign) CGColorRef textColorY;

@end