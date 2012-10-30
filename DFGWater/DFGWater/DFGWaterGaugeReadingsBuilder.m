//
//  DFGWaterGaugeReadingsBuilder.m
//  DFGWater
//
//  Created by Brian DeShong on 10/29/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeReadingsBuilder.h"
#import "DFGWaterReading.h"
#import "DFGWaterDateMaker.h"

@implementation DFGWaterGaugeReadingsBuilder
{
    DFGWaterDateMaker* dateMaker;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        dateMaker = [[DFGWaterDateMaker alloc] init];
    }
    
    return self;
}

- (NSArray*)buildReadings:(NSDictionary*)rawReadingValues
{
    NSMutableArray* readings = [[NSMutableArray alloc] initWithCapacity:10];
    NSString* unit = [rawReadingValues objectForKey:@"unit"];
    
    for (NSDictionary* rawReading in [(NSDictionary*)rawReadingValues objectForKey:@"values"]) {
        NSDate* date = [dateMaker dateFromISODateString:[rawReading objectForKey:@"when"]];
        
        DFGWaterReading* reading = [[DFGWaterReading alloc] initWithValue:[rawReading objectForKey:@"value"] unit:unit atDate:date];
        
        [readings addObject:reading];
    }
    
    return [NSArray arrayWithArray:readings];
}

@end
