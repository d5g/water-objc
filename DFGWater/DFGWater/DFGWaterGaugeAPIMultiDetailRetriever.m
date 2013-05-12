//
//  DFGWaterGaugeAPIMultiDetailRetriever.m
//  DFGWater
//
//  Created by Brian DeShong on 5/12/13.
//  Copyright (c) 2013 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeAPIMultiDetailRetriever.h"

@implementation DFGWaterGaugeAPIMultiDetailRetriever

@synthesize requestBuilder;
@synthesize responseParser;

- (id)initWithRequestBuilder:(id<DFGWaterGaugeMultiDetailRequestBuilderProtocol>)theRequestBuilder
           theResponseParser:(id<DFGWaterGaugeMultiDetailResponseParserProtocol>)theResponseParser
{
    if (self = [super init]) {
        [self setRequestBuilder:theRequestBuilder];
        [self setResponseParser:theResponseParser];
    }
    
    return self;
}

- (BOOL)retrieveForGauges:(NSArray*)gauges
              detailLevel:(DFGWaterGaugeMultiDetailLevel)detailLevel
             successBlock:(DFGWaterGaugeMultiDetailRetrieverSuccessBlock)theSuccessBlock
               errorBlock:(DFGWaterGaugeMultiDetailRetrieverErrorBlock)theErrorBlock
{
    return YES;
}

@end
