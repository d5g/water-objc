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
        NSString* unit = [reading objectForKey:@"unit"];
        
        DFGWaterReading* lastHeightReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        
        [gauge setLastHeightReading:lastHeightReading];
    }
    
    [gauge setHasHeight:[dict valueForKeyPath:@"gauge.readings.height"] != nil];
    [gauge setHasPrecipitation:[dict valueForKeyPath:@"gauge.readings.precipitation"] != nil];
    [gauge setHasDischarge:[dict valueForKeyPath:@"gauge.readings.discharge"] != nil];
    [gauge setHasWaterTemperature:[dict valueForKeyPath:@"gauge.readings.water_temperature"] != nil];
    
    return YES;
}

@end
