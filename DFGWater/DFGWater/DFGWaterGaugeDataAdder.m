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
#import "DFGWaterGaugeForecast.h"

@interface DFGWaterGaugeDataAdder ()

- (BOOL)addGaugeNodeData:(NSDictionary*)dict toGauge:(DFGWaterGauge*)gauge;

@end

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
    return [self addGaugeNodeData:[dict valueForKeyPath:@"gauge"] toGauge:gauge];
}

- (BOOL)addMultiGaugeData:(NSDictionary*)dict toGauges:(NSArray*)gauges
{
    for (NSDictionary* gaugeData in [dict valueForKeyPath:@"gauges"]) {
        NSString* gaugeID = [dict valueForKey:@"id"];
        NSPredicate* findGaugePredicate = [NSPredicate predicateWithFormat:@"gaugeID = %@", gaugeID];
        NSArray* matches = [gauges filteredArrayUsingPredicate:findGaugePredicate];

        if ([matches count] == 0) {
            NSException* exception = [NSException exceptionWithName:@"MultipleGaugeMatchesFoundException"
                                                             reason:[NSString stringWithFormat:@"no gauges found with gaugeID '%@'", gaugeID]
                                                           userInfo:nil];
            @throw exception;
        } else if ([matches count] > 1) {
            NSException* exception = [NSException exceptionWithName:@"MultipleGaugeMatchesFoundException"
                                                             reason:[NSString stringWithFormat:@"multiple gauges found with gaugeID '%@'", gaugeID]
                                                           userInfo:nil];
            @throw exception;
        }
        
        DFGWaterGauge* gauge = [matches objectAtIndex:0];
        
        [self addGaugeNodeData:dict toGauge:gauge];
    }
    
    return YES;
}

- (BOOL)addGaugeNodeData:(NSDictionary*)dict toGauge:(DFGWaterGauge*)gauge;
{
    NSDictionary* reading;
    NSDictionary* rawReadings;

    [gauge setHasHeight:[dict valueForKeyPath:@"readings.height"] != nil];
    [gauge setHasPrecipitation:[dict valueForKeyPath:@"readings.precipitation"] != nil];
    [gauge setHasDischarge:[dict valueForKeyPath:@"readings.discharge"] != nil];
    [gauge setHasWaterTemperature:[dict valueForKeyPath:@"readings.water_temperature"] != nil];
    
    DFGWaterDateMaker* dateMaker = [[DFGWaterDateMaker alloc] init];

    if ((reading = [dict valueForKeyPath:@"readings.height.last_reading"])) {
        NSString* value = [NSString stringWithFormat:@"%@", [reading objectForKey:@"value"]];
        
        NSDate* date = [dateMaker dateFromISODateString:[reading objectForKey:@"when"]];
        NSString* unit = [reading objectForKey:@"unit"];
        
        DFGWaterReading* lastHeightReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        
        [gauge setLastHeightReading:lastHeightReading];
    }

    if ((reading = [dict valueForKeyPath:@"readings.precipitation.past_24_hours"])) {
        NSString* value = [NSString stringWithFormat:@"%@", [reading objectForKey:@"value"]];
        NSDate* date = [dateMaker dateFromISODateString:[reading objectForKey:@"when"]];
        NSString* unit = [reading objectForKey:@"unit"];
        
        DFGWaterReading* precipitationPast24HoursReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        
        [gauge setPrecipitationPast24HoursReading:precipitationPast24HoursReading];
    }
    
    if ((reading = [dict valueForKeyPath:@"readings.precipitation.past_7_days"])) {
        NSString* value = [NSString stringWithFormat:@"%@", [reading objectForKey:@"value"]];
        NSDate* date = [dateMaker dateFromISODateString:[reading objectForKey:@"when"]];
        NSString* unit = [reading objectForKey:@"unit"];
        
        DFGWaterReading* precipitationPast7DaysReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        
        [gauge setPrecipitationPast7DaysReading:precipitationPast7DaysReading];
    }

    if ((reading = [dict valueForKeyPath:@"readings.discharge.last_reading"])) {
        NSString* value = [NSString stringWithFormat:@"%@", [reading objectForKey:@"value"]];
        NSDate* date = [dateMaker dateFromISODateString:[reading objectForKey:@"when"]];
        NSString* unit = [reading objectForKey:@"unit"];
        
        DFGWaterReading* lastDischargeReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        
        [gauge setLastDischargeReading:lastDischargeReading];
    }

    if ((reading = [dict valueForKeyPath:@"readings.water_temperature.last_reading"])) {
        NSString* value = [NSString stringWithFormat:@"%@", [reading objectForKey:@"value"]];
        NSDate* date = [dateMaker dateFromISODateString:[reading objectForKey:@"when"]];
        NSString* unit = [reading objectForKey:@"unit"];
        
        DFGWaterReading* lastWaterTemperatureReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        
        [gauge setLastWaterTemperatureReading:lastWaterTemperatureReading];
    }
    
    //
    // Setup the raw values for the readings.
    //
    
    if ((rawReadings = [dict valueForKeyPath:@"readings.height.raw_values"])) {
        NSArray* readings = [readingsBuilder buildReadings:rawReadings];
        [gauge setHeightReadings:readings];
    }

    if ((rawReadings = [dict valueForKeyPath:@"readings.precipitation.raw_values"])) {
        NSArray* readings = [readingsBuilder buildReadings:rawReadings];
        [gauge setPrecipitationReadings:readings];
    }

    if ((rawReadings = [dict valueForKeyPath:@"readings.discharge.raw_values"])) {
        NSArray* readings = [readingsBuilder buildReadings:rawReadings];
        [gauge setDischargeReadings:readings];
    }

    if ((rawReadings = [dict valueForKeyPath:@"readings.water_temperature.raw_values"])) {
        NSArray* readings = [readingsBuilder buildReadings:rawReadings];
        [gauge setWaterTemperatureReadings:readings];
    }
    
    //
    // Setup gauge height status.
    //
    
    id heightStatus = [dict valueForKeyPath:@"gauge.readings.height.status"];
    
    if (heightStatus != [NSNull null]) {
        DFGWaterGaugeHeightStatusType status;
        
        if ([(NSString*)heightStatus isEqualToString:@"rising"]) {
            status = kDFGWaterGaugeHeightStatusRising;
        } else if ([(NSString*)heightStatus isEqualToString:@"falling"]) {
            status = kDFGWaterGaugeHeightStatusFalling;
        } else if ([(NSString*)heightStatus isEqualToString:@"steady"]) {
            status = kDFGWaterGaugeHeightStatusSteady;
        } else {
            status = kDFGWaterGaugeHeightStatusUnknown;
        }
        
        [gauge setHeightStatus:status];
    }
    
    //
    // Setup the raw values for the flood stages
    //
    
    id rawStages = [dict valueForKeyPath:@"stages"];
    
    if (rawStages != [NSNull null]) {
        id actionHeight = [(NSDictionary*)rawStages objectForKey:@"action_height"];
        id floodHeight = [(NSDictionary*)rawStages objectForKey:@"flood_height"];
        id moderateHeight = [(NSDictionary*)rawStages objectForKey:@"moderate_height"];
        id majorHeight = [(NSDictionary*)rawStages objectForKey:@"major_height"];
        NSString* stageUnit = [(NSDictionary*)rawStages objectForKey:@"unit"];
        
        DFGWaterGaugeStages* stages = [[DFGWaterGaugeStages alloc] init];
        
        if (actionHeight != [NSNull null]) {
            DFGWaterGaugeStage* actionStage = [[DFGWaterGaugeStage alloc] init];
            [actionStage setName:@"Action"];
            [actionStage setValue:[actionHeight floatValue]];
            [actionStage setUnit:stageUnit];
            [stages setAction:actionStage];
        }
        
        if (floodHeight != [NSNull null]) {
            DFGWaterGaugeStage* floodStage = [[DFGWaterGaugeStage alloc] init];
            [floodStage setName:@"Flood"];
            [floodStage setValue:[floodHeight floatValue]];
            [floodStage setUnit:stageUnit];
            [stages setFlood:floodStage];
        }
        
        if (moderateHeight != [NSNull null]) {
            DFGWaterGaugeStage* moderateStage = [[DFGWaterGaugeStage alloc] init];
            [moderateStage setName:@"Moderate"];
            [moderateStage setValue:[moderateHeight floatValue]];
            [moderateStage setUnit:stageUnit];
            [stages setModerate:moderateStage];
        }

        if (majorHeight != [NSNull null]) {
            DFGWaterGaugeStage* majorStage = [[DFGWaterGaugeStage alloc] init];
            [majorStage setName:@"Major"];
            [majorStage setValue:[majorHeight floatValue]];
            [majorStage setUnit:stageUnit];
            [stages setMajor:majorStage];
        }
        
        if ([stages hasStage]) {
            [gauge setStages:stages];
        }
    }
    
    //
    // Forecasts
    //
    
    // Height
    id forecastHeight = [dict valueForKeyPath:@"forecast.height"];
    
    if (forecastHeight != [NSNull null]) {
        NSDictionary* highest = [(NSDictionary*)forecastHeight objectForKey:@"highest"];
        DFGWaterReading* heightHighestReading = nil;
        NSDate* issued = nil;
        
        if (highest) {
            NSString* unit = [highest objectForKey:@"unit"];
            NSString* value = [NSString stringWithFormat:@"%.4f", [[highest objectForKey:@"value"] floatValue]];
            NSDate* date = [dateMaker dateFromISODateString:[highest objectForKey:@"when"]];
            issued = [dateMaker dateFromISODateString:[highest objectForKey:@"issued"]];
            
            heightHighestReading = [[DFGWaterReading alloc] initWithValue:value unit:unit atDate:date];
        }

        if (heightHighestReading) {
            DFGWaterGaugeForecast* heightForecast = [[DFGWaterGaugeForecast alloc] init];
            [heightForecast setHighestReading:heightHighestReading];
            [heightForecast setIssued:issued];
            [gauge setHeightForecast:heightForecast];
        }
    }

    return YES;
}

@end
