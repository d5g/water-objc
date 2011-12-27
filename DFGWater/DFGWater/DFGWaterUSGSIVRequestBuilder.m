//
//  DFGWaterUSGSIVRequestBuilder.m
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterUSGSIVRequestBuilder.h"
#import "DFGWaterGaugeDataRequestParameters.h"

@implementation DFGWaterUSGSIVRequestBuilder

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
}

@end
