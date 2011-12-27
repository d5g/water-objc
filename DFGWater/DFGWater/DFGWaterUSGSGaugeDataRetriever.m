//
//  DFGWaterUSGSGaugeDataRetriever.m
//  DFGWater
//
//  Created by Brian DeShong on 12/24/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterUSGSGaugeDataRetriever.h"

@implementation DFGWaterUSGSGaugeDataRetriever

@synthesize operationQueue;
@synthesize requestBuilder;
@synthesize responseParser;

- (id)initWithOperationQueue:(NSOperationQueue*)theOperationQueue
              requestBuilder:(id<DFGWaterServiceRequestBuilderProtocol>)theRequestBuilder
              responseParser:(id<DFGWaterServiceResponseParserProtocol>)theResponseParser
{
    self = [super init];
    
    if (self) {
        operationQueue = theOperationQueue;
        requestBuilder = theRequestBuilder;
        responseParser = theResponseParser;
    }
    
    return self;
}

- (BOOL)retrieveData:(DFGWaterGaugeDataRequestParameters*)params
               error:(NSError**)error
{
    if (params == nil) {
        if (error != NULL) {
            NSDictionary* userDict = [NSDictionary dictionaryWithObject:@"must pass non-nil parameters"
                                                                 forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:[self errorDomain]
                                         code:DFGWaterGaugeDataRetrieverErrorInadequateParameters
                                     userInfo:userDict];
        }
        
        return NO;
    }

    NSError* requestError;
    NSURLRequest* request = [requestBuilder buildRequest:params error:&requestError];
    
    if (!request) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:[self errorDomain]
                                         code:DFGWaterGaugeDataRetrieverErrorUnableToBuildRequest
                                     userInfo:nil];
        }
        
        return NO;
    }
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:operationQueue
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
                               NSLog(@"done for %@; got data: %@", params, data);
                           }];
    
    sleep(10);
    return YES;
}

#pragma mark -
#pragma mark DFGError methods

- (NSString*)errorDomain
{
    return @"DFGWaterUSGSGaugeDataRetrieverErrors";
}

@end
