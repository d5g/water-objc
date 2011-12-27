//
//  DFGWaterUSGSIVRequestBuilder.m
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterUSGSIVJSONRequestBuilder.h"
#import "DFGWaterGaugeDataRequestParameters.h"
#import "DFGWaterGauge.h"

@implementation DFGWaterUSGSIVJSONRequestBuilder

/**
 *
 * Multiple sites, multiple values, past 6 hours:
 * http://waterservices.usgs.gov/nwis/iv?format=json,1.1&sites=02336910,02337000&period=PT6H&parameterCd=00060,00065
 *
 * Single site, most recent value:
 * http://waterservices.usgs.gov/nwis/iv?format=json,1.1&sites=01646500&parameterCd=00060,00065
 */
- (NSURLRequest*)buildRequest:(DFGWaterGaugeDataRequestParameters*)theParameters
                        error:(NSError**)error
{
    NSMutableArray* gaugeIDs = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray* parameters = [NSMutableArray arrayWithCapacity:1];
    
    for (DFGWaterGauge* gauge in [theParameters gauges]) {
        [gaugeIDs addObject:[gauge gaugeID]];
    }
    
    if ([theParameters height]) {
        [parameters addObject:@"00065"];
    }
    
    if ([theParameters precipitation]) {
        [parameters addObject:@"00045"];
    }
    
    if ([theParameters discharge]) {
        [parameters addObject:@"00060"];
    }
    
    NSString* periodKeyValuePair = @"";
    
    // If numDaysAgo, built P[x]D
    if ([theParameters numDaysAgo]) {
        periodKeyValuePair = [NSString stringWithFormat:@"period=P%uD", [theParameters numDaysAgo]];
    } else if ([theParameters sinceDate] && [theParameters endDate]) {
        periodKeyValuePair = @"TODO=fixme";
    }
    
    // If since/end dates, build sinceDate and endDate
    
    NSString* urlString = [NSString stringWithFormat:@"http://waterservices.usgs.gov/nwis/iv?format=json,1.1&sites=%@&%@&parameterCd=%@", [gaugeIDs componentsJoinedByString:@","], periodKeyValuePair, [parameters componentsJoinedByString:@","]];
    NSURL* url = [NSURL URLWithString:urlString];
    return [NSURLRequest requestWithURL:url];
}

@end
