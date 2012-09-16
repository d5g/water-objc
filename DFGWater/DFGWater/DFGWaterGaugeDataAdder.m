//
//  DFGWaterGaugeDataAdder.m
//  DFGWater
//
//  Created by Brian DeShong on 9/15/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeDataAdder.h"
#import "DFGWaterGauge.h"
#import "DFGWaterReading.h"
#import "DFGWaterDateMaker.h"

@implementation DFGWaterGaugeDataAdder

- (BOOL)addData:(NSDictionary*)dict toGauge:(DFGWaterGauge*)gauge
{
    NSDictionary* reading;
    
    if ((reading = [dict valueForKeyPath:@"gauge.readings.height.last_reading"])) {
        NSString* value = [NSString stringWithFormat:@"%@", [reading objectForKey:@"value"]];
        
        DFGWaterDateMaker* dateMaker = [[DFGWaterDateMaker alloc] init];
        NSDate* date = [dateMaker dateFromISODateString:[reading objectForKey:@"when"]];
        
        DFGWaterReading* lastHeightReading = [[DFGWaterReading alloc] initWithValue:value atDate:date];
        
        [gauge setLastHeightReading:lastHeightReading];
    }
    
    return YES;
}

@end
