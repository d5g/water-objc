//
//  DFGWaterGaugeFinderAPIRequestBuilder.m
//  DFGWater
//
//  Created by Brian DeShong on 5/27/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeFinderAPIRequestBuilder.h"
#import "DFGWaterGaugeFinderContext.h"

@implementation DFGWaterGaugeFinderAPIRequestBuilder

- (NSURLRequest*)buildWithLatitude:(float)theLatitude
                         longitude:(float)theLongitude
                     radiusInMiles:(float)theRadius
                            agency:(NSString*)theAgency
                             limit:(NSUInteger)theLimit
{
    // http://api.d5gtech.com/water/v1/gauges?type=location&latitude=33.826977&longitude=-84.640657
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(theLatitude, theLongitude);
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.d5gtech.com/water/v1/gauges?type=location&latitude=%f&longitude=%f", coord.latitude, coord.longitude]];
    
    return [NSURLRequest requestWithURL:url];
}

@end
