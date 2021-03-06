//
//  DFGWaterGaugeDetailAPIRequestBuilder.m
//  DFGWater
//
//  Created by Brian DeShong on 9/13/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeDetailAPIRequestBuilder.h"
#import "DFGWaterGauge.h"

@implementation DFGWaterGaugeDetailAPIRequestBuilder

@synthesize baseURLString;
@synthesize version;

- (id)initWithBaseURLString:(NSString*)theBaseURLString
                    version:(NSString*)theVersion
{
    if (self = [super init]) {
        baseURLString = [theBaseURLString copy];
        version = [theVersion copy];
    }
    
    return self;
}

- (NSURLRequest*)buildWithGauge:(DFGWaterGauge*)gauge
{    
    NSString* urlString = [NSString stringWithFormat:@"%@/water/%@/gauge/%@/%@", baseURLString, version, [gauge agencySlug], [gauge agencyGaugeID]];
    NSURL* url = [NSURL URLWithString:urlString];

    // TODO: centralize cache disabling and timeout?
    return [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
}

@end
