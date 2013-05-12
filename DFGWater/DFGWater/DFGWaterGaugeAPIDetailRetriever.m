//
//  DFGWaterGaugeAPIDetailRetriever.m
//  DFGWater
//
//  Created by Brian DeShong on 9/15/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeAPIDetailRetriever.h"
#import "DFGWaterGaugeDetailRequestBuilderProtocol.h"
#import "DFGWaterGaugeDetailResponseParserProtocol.h"
#import "DFGWaterGaugeDataAdder.h"

@implementation DFGWaterGaugeAPIDetailRetriever

@synthesize requestBuilder;
@synthesize responseParser;

- (id)initWithRequestBuilder:(id<DFGWaterGaugeDetailRequestBuilderProtocol>)theRequestBuilder
              responseParser:(id<DFGWaterGaugeDetailResponseParserProtocol>)theResponseParser
{
    if (self = [super init]) {
        self.requestBuilder = theRequestBuilder;
        self.responseParser = theResponseParser;
    }
    
    return self;
}

- (BOOL)retrieveForGauge:(DFGWaterGauge*)gauge
            successBlock:(DFGWaterGaugeDetailRetrieverSuccessBlock)theSuccessBlock
              errorBlock:(DFGWaterGaugeDetailRetrieverErrorBlock)theErrorBlock
{
    NSURLRequest* request = [requestBuilder buildWithGauge:gauge];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURLResponse* response;
        NSError* error;
        
        __weak NSURLRequest* weakRequest = request;
        
        NSData* data = [NSURLConnection sendSynchronousRequest:weakRequest
                                             returningResponse:&response
                                                         error:&error];
        
        NSDictionary* allGaugeData = [[self responseParser] parseResponse:response withData:data error:&error];
        
        DFGWaterGaugeDataAdder* dataAdder = [[DFGWaterGaugeDataAdder alloc] init];
        [dataAdder addData:allGaugeData toGauge:gauge];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            theSuccessBlock(gauge);
        });
    });
    
    return YES;
}

@end
