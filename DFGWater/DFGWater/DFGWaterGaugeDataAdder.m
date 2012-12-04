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
#import "DFGWaterGaugeReadingsBuilder.h"
#import "DFGWaterGaugeStages.h"
#import "DFGWaterGaugeStage.h"

@implementation DFGWaterGaugeDataAdder
{
    DFGWaterGaugeReadingsBuilder* readingsBuilder;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        readingsBuilder = [[DFGWaterGaugeReadingsBuilder alloc] init];
    }
    
    return self;
}

- (BOOL)addData:(NSDictionary*)dict toGauge:(DFGWaterGauge*)gauge
{
    NSDictionary* reading;
    NSDictionary* rawReadings;

    [gauge setHasHeight:[dict valueForKeyPath:@"gauge.readings.height"] != nil];
    [gauge setHasPrecipitation:[dict valueForKeyPath:@"gauge.readings.precipitation"] != nil];
    [gauge setHasDischarge:[dict valueForKeyPath:@"gauge.readings.discharge"] != nil];
    [gauge setHasWaterTemperature:[dict valueForKeyPath:@"gauge.readings.water_temperature"] != nil];
    
    DFGWaterDateMaker* dateMaker = [[DFGWaterDateMaker alloc] init];

    if ((reading = [dict valueForKeyPath:@"gauge.readings.height.last_reading"])) {
        NSString* value = [NSString stringWithFormat:@"%@", [reading objectForKey:@"value"]];
        
        NSDate* date = [dateMaker dateFromISODateString:[reading objectForKey:@"when"]];
        NSString* unit = [reading objectForKey:@"unit"];
        
        DFGWaterReading* lastHeightReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        
        [gauge setLastHeightReading:lastHeightReading];
    }

    if ((reading = [dict valueForKeyPath:@"gauge.readings.precipitation.past_24_hours"])) {
        NSString* value = [NSString stringWithFormat:@"%@", [reading objectForKey:@"value"]];
        NSDate* date = [dateMaker dateFromISODateString:[reading objectForKey:@"when"]];
        NSString* unit = [reading objectForKey:@"unit"];
        
        DFGWaterReading* precipitationPast24HoursReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        
        [gauge setPrecipitationPast24HoursReading:precipitationPast24HoursReading];
    }
    
    if ((reading = [dict valueForKeyPath:@"gauge.readings.precipitation.past_7_days"])) {
        NSString* value = [NSString stringWithFormat:@"%@", [reading objectForKey:@"value"]];
        NSDate* date = [dateMaker dateFromISODateString:[reading objectForKey:@"when"]];
        NSString* unit = [reading objectForKey:@"unit"];
        
        DFGWaterReading* precipitationPast7DaysReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        
        [gauge setPrecipitationPast7DaysReading:precipitationPast7DaysReading];
    }

    if ((reading = [dict valueForKeyPath:@"gauge.readings.discharge.last_reading"])) {
        NSString* value = [NSString stringWithFormat:@"%@", [reading objectForKey:@"value"]];
        NSDate* date = [dateMaker dateFromISODateString:[reading objectForKey:@"when"]];
        NSString* unit = [reading objectForKey:@"unit"];
        
        DFGWaterReading* lastDischargeReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        
        [gauge setLastDischargeReading:lastDischargeReading];
    }

    if ((reading = [dict valueForKeyPath:@"gauge.readings.water_temperature.last_reading"])) {
        NSString* value = [NSString stringWithFormat:@"%@", [reading objectForKey:@"value"]];
        NSDate* date = [dateMaker dateFromISODateString:[reading objectForKey:@"when"]];
        NSString* unit = [reading objectForKey:@"unit"];
        
        DFGWaterReading* lastWaterTemperatureReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        
        [gauge setLastWaterTemperatureReading:lastWaterTemperatureReading];
    }
    
    //
    // Setup the raw values for the readings.
    //
    
    if ((rawReadings = [dict valueForKeyPath:@"gauge.readings.height.raw_values"])) {
        NSArray* readings = [readingsBuilder buildReadings:rawReadings];
        [gauge setHeightReadings:readings];
    }

    if ((rawReadings = [dict valueForKeyPath:@"gauge.readings.precipitation.raw_values"])) {
        NSArray* readings = [readingsBuilder buildReadings:rawReadings];
        [gauge setPrecipitationReadings:readings];
    }

    if ((rawReadings = [dict valueForKeyPath:@"gauge.readings.discharge.raw_values"])) {
        NSArray* readings = [readingsBuilder buildReadings:rawReadings];
        [gauge setDischargeReadings:readings];
    }

    if ((rawReadings = [dict valueForKeyPath:@"gauge.readings.water_temperature.raw_values"])) {
        NSArray* readings = [readingsBuilder buildReadings:rawReadings];
        [gauge setWaterTemperatureReadings:readings];
    }
    
    //
    // Setup the raw values for the flood stages
    //
    
    NSDictionary* rawStages = [dict valueForKeyPath:@"gauge.stages"];
    
    if (rawStages) {
        float actionHeight = [[rawStages objectForKey:@"action_height"] floatValue];
        float floodHeight = [[rawStages objectForKey:@"flood_height"] floatValue];
        float moderateHeight = [[rawStages objectForKey:@"moderate_height"] floatValue];
        float majorHeight = [[rawStages objectForKey:@"major_height"] floatValue];
        
        DFGWaterGaugeStages* stages = [[DFGWaterGaugeStages alloc] init];
        
        if (actionHeight) {
            DFGWaterGaugeStage* actionStage = [[DFGWaterGaugeStage alloc] init];
            [actionStage setName:@"Action"];
            [actionStage setValue:actionHeight];
            [stages setAction:actionStage];
        }
        
        if (floodHeight) {
            DFGWaterGaugeStage* floodStage = [[DFGWaterGaugeStage alloc] init];
            [floodStage setName:@"Flood"];
            [floodStage setValue:floodHeight];
            [stages setFlood:floodStage];
        }
        
        if (moderateHeight) {
            DFGWaterGaugeStage* moderateStage = [[DFGWaterGaugeStage alloc] init];
            [moderateStage setName:@"Moderate"];
            [moderateStage setValue:moderateHeight];
            [stages setModerate:moderateStage];
        }

        if (majorHeight) {
            DFGWaterGaugeStage* majorStage = [[DFGWaterGaugeStage alloc] init];
            [majorStage setName:@"Major"];
            [majorStage setValue:moderateHeight];
            [stages setMajor:majorStage];
        }
        
        if ([stages hasStage]) {
            [gauge setStages:stages];
        }
    }

    return YES;
}

@end
