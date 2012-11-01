//
//  DFGWaterReadingsDataExtractor.m
//  DFGWater
//
//  Created by Brian DeShong on 10/31/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterReadingsDataExtractor.h"

@implementation DFGWaterReadingsDataExtractor

- (NSString*)minValue:(NSArray*)readings
{
    if (![readings count]) {
        return nil;
    }
    
    return [readings valueForKeyPath:@"@min.value"];
}

- (NSString*)maxValue:(NSArray*)readings
{
    if (![readings count]) {
        return nil;
    }
    
    return [readings valueForKeyPath:@"@max.value"];
}

- (NSDate*)minDate:(NSArray*)readings
{
    if (![readings count]) {
        return nil;
    }
    
    return [readings valueForKeyPath:@"@min.date"];
}

- (NSDate*)maxDate:(NSArray*)readings
{
    if (![readings count]) {
        return nil;
    }
    
    return [readings valueForKeyPath:@"@max.date"];
}


@end
