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
    // Build arrays of the gauge IDs we're retrieving for and the USGS
    // parameter codes that we're retrieving.
    NSMutableArray* gaugeIDs = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray* parameters = [NSMutableArray arrayWithCapacity:1];
    
    for (DFGWaterGauge* gauge in [theParameters gauges]) {
        [gaugeIDs addObject:[gauge gaugeID]];
    }

    // See all USGS parameters at http://nwis.waterdata.usgs.gov/nwis/pmcodes/
    
    // 00065 = gauge height, in feet
    if ([theParameters height]) {
        [parameters addObject:@"00065"];
    }
    
    // 00045 = precipitation, in inches
    if ([theParameters precipitation]) {
        [parameters addObject:@"00045"];
    }
    
    // 00060 = discharge, in cubic feet/second
    if ([theParameters discharge]) {
        [parameters addObject:@"00060"];
    }
    
    NSString* periodKeyValuePair = @"";
    
    // If numDaysAgo, built P[x]D
    if ([theParameters numDaysAgo]) {
        periodKeyValuePair = [NSString stringWithFormat:@"period=P%uD", [theParameters numDaysAgo]];
    } else if ([theParameters sinceDate] && [theParameters endDate]) {
        // See http://waterservices.usgs.gov/rest/IV-Test-Tool.html
        //
        // ISO-8601 format: http://en.wikipedia.org/wiki/ISO-8601#Dates
        //
        // &startDT=2010-07-01T12:00Z (Universal time)
        // If you do not specify an hour, T00:00 for the start date is assumed.
        //
        // NOTE: not more than 120 days
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm'Z'"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        NSString* startDateString = [formatter stringFromDate:[theParameters sinceDate]];
        NSString* endDateString = [formatter stringFromDate:[theParameters endDate]];
        
        periodKeyValuePair = [NSString stringWithFormat:@"startDT=%@&endDT=%@", startDateString, endDateString];
    }
    
    // If since/end dates, build sinceDate and endDate
    
    NSString* urlString = [NSString stringWithFormat:@"http://waterservices.usgs.gov/nwis/iv?format=json,1.1&sites=%@&%@&parameterCd=%@", [gaugeIDs componentsJoinedByString:@","], periodKeyValuePair, [parameters componentsJoinedByString:@","]];
    
    NSLog(@"built with %@", urlString);
    
    NSURL* url = [NSURL URLWithString:urlString];
    return [NSURLRequest requestWithURL:url];
}

@end
