//
//  DFGWaterReadingsDataExtractor.h
//  DFGWater
//
//  Created by Brian DeShong on 10/31/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFGWaterReadingsDataExtractor : NSObject

- (NSString*)minValue:(NSArray*)readings;
- (NSString*)maxValue:(NSArray*)readings;

- (NSDate*)minDate:(NSArray*)readings;
- (NSDate*)maxDate:(NSArray*)readings;


@end
