//
//  DFGGaugesByLocationRequestBuilder.m
//  FloodWatch
//
//  Created by Brian DeShong on 8/9/12.
//  Copyright (c) 2012 Brian DeShong. All rights reserved.
//

#import "DFGWaterGaugeFinderAPIRequestBuilder.h"

@implementation DFGWaterGaugeFinderAPIRequestBuilder

@synthesize baseURLString;

- (id)initWithBaseURLString:(NSString*)theBaseURLString
{
    if (self = [super init]) {
        [self setBaseURLString:theBaseURLString];
    }
    
    return self;
}

- (NSURLRequest*)buildWithLatitude:(float)theLatitude
                         longitude:(float)theLongitude
                     radiusInMiles:(float)theRadius
                            agency:(NSString*)theAgency
                             limit:(NSUInteger)theLimit
{
    NSString* agencyParameter = @"";
    NSString* limitParameter = @"";
    
    if (theAgency) {
        agencyParameter = [NSString stringWithFormat:@"&agency=%@", theAgency];
    }
    
    if (theLimit) {
        limitParameter = [NSString stringWithFormat:@"&limit=%d", theLimit];
    }
    
    NSString* urlString = [NSString stringWithFormat:@"%@/water/v1/gauges?type=location&latitude=%f&longitude=%f%@%@",
                           [self baseURLString],
                           theLatitude,
                           theLongitude,
                           agencyParameter,
                           limitParameter];
    
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                        timeoutInterval:30.0];
}

@end
