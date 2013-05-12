//
//  DFGWaterGaugeMultiDetailAPIRequestBuilder.m
//  DFGWater
//
//  Created by Brian DeShong on 5/1/13.
//  Copyright (c) 2013 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeMultiDetailAPIRequestBuilder.h"
#import "DFGWaterGauge.h"

@interface DFGWaterGaugeMultiDetailAPIRequestBuilder ()

- (NSString*)detailLevelString:(DFGWaterGaugeMultiDetailLevel)detailLevel;
- (NSString*)gaugesIdsString:(NSArray*)gauges;

@end

@implementation DFGWaterGaugeMultiDetailAPIRequestBuilder

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

- (NSURLRequest*)buildWithGauges:(NSArray*)gauges
                     detailLevel:(DFGWaterGaugeMultiDetailLevel)detailLevel;
{
    NSString* urlString = [NSString stringWithFormat:@"%@/water/%@/gauge/%@/%@", baseURLString, version, [self detailLevelString:detailLevel], [self gaugesIdsString:gauges]];
    NSURL* url = [NSURL URLWithString:urlString];
    
    // TODO: centralize cache disabling and timeout?
    return [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
}

- (NSString*)detailLevelString:(DFGWaterGaugeMultiDetailLevel)detailLevel
{
    if (detailLevel == kDFGWaterGaugeMultiDetailLevelBasic) {
        return @"basic";
    }
    
    return nil;
}

- (NSString*)gaugesIdsString:(NSArray*)gauges
{
    NSMutableString* idsString = [[NSMutableString alloc] initWithCapacity:10];
    
    for (DFGWaterGauge* gauge in gauges) {
        [idsString appendFormat:@"%@", [gauge gaugeID]];
    }
    
    return [NSString stringWithString:idsString];
}

@end
