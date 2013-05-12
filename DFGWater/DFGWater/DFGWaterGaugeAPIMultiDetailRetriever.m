//
//  DFGWaterGaugeAPIMultiDetailRetriever.m
//  DFGWater
//
//  Created by Brian DeShong on 5/12/13.
//  Copyright (c) 2013 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeAPIMultiDetailRetriever.h"
#import "DFGWater/DFGWater.h"

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
    NSURLRequest* request = [requestBuilder buildWithGauges:gauges
                                                detailLevel:detailLevel];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURLResponse* response;
        NSError* error;
        
        __weak NSURLRequest* weakRequest = request;
        
        NSData* data = [NSURLConnection sendSynchronousRequest:weakRequest
                                             returningResponse:&response
                                                         error:&error];
        
        NSDictionary* allGaugeData = [[self responseParser] parseResponse:response withData:data error:&error];
        
        DFGWaterGaugeDataAdder* dataAdder = [[DFGWaterGaugeDataAdder alloc] init];

        // TODO: make data adder take an array of gauges and an array of dictionaries
        // and pair them up correctly?
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            theSuccessBlock(gauges, detailLevel);
        });
    });
    
    return YES;
}

@end
