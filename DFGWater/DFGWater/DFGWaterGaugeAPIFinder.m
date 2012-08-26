//
//  DFGGaugesByLocationRetriever.m
//  FloodWatch
//
//  Created by Brian DeShong on 8/9/12.
//  Copyright (c) 2012 Brian DeShong. All rights reserved.
//

#import "DFGWaterGaugeAPIFinder.h"

@implementation DFGWaterGaugeAPIFinder

@synthesize requestBuilder;

- (id)initWithRequestBuilder:(id<DFGWaterGaugeFinderRequestBuilderProtocol>)theRequestBuilder
              responseParser:(id<DFGWaterGaugeFinderResponseParserProtocol>)theResponseParser
{
    if (self = [super init]) {
        [self setRequestBuilder:theRequestBuilder];
        [self setResponseParser:theResponseParser];
    }
    
    return self;
}

- (BOOL)retrieveWithLocation:(CLLocationCoordinate2D)theCoordinate
               radiusInMiles:(float)theRadius
                      agency:(NSString*)theAgency
                       limit:(NSUInteger)theLimit
                successBlock:(DFGGaugesByLocationRetrieverSuccessBlock)theSuccessBlock
                  errorBlock:(DFGGaugesByLocationRetrieverErrorBlock)theErrorBlock
{
    NSURLRequest* request = [requestBuilder buildWithLatitude:theCoordinate.latitude
                                                    longitude:theCoordinate.longitude
                                                radiusInMiles:theRadius
                                                       agency:theAgency
                                                        limit:theLimit];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURLResponse* response;
        NSError* error;
        
        NSData* data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        
        NSArray* theGauges = [[self responseParser] parseResponse:response withData:data error:&error];
        dispatch_sync(dispatch_get_main_queue(), ^{
            theSuccessBlock(theGauges);
        });
    });
    
    return YES;
}

@end