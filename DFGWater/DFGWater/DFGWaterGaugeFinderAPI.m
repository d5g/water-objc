//
//  DFGWaterGaugeFinderAPI.m
//  DFGWater
//
//  Created by Brian DeShong on 5/27/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeFinderAPI.h"
#import "DFGWaterGaugeFinderDelegateProtocol.h"

@implementation DFGWaterGaugeFinderAPI

@synthesize operationQueue;
@synthesize requestBuilder;
@synthesize responseParser;

- (id)initWithOperationQueue:(NSOperationQueue*)theOperationQueue
              requestBuilder:(id<DFGWaterGaugeFinderRequestBuilderProtocol>)theRequestBuilder
              responseParser:(id<DFGWaterGaugeFinderResponseParserProtocol>)theResponseParser
{
    self = [super init];
    
    if (self) {
        operationQueue = theOperationQueue;
        requestBuilder = theRequestBuilder;
        responseParser = theResponseParser;
    }
    
    return self;
}

- (BOOL)findByContext:(DFGWaterGaugeFinderContext*)context
                error:(NSError**)error
{
    if (context == nil) {
        if (error != NULL) {
            NSDictionary* userDict = [NSDictionary dictionaryWithObject:@"must pass non-nil context"
                                                                 forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:[self errorDomain]
                                         code:DFGWaterGaugeFinderErrorInadequateParameters
                                     userInfo:userDict];
        }
        
        return NO;
    }
    
    NSError* requestError;
    NSURLRequest* request = [requestBuilder buildRequest:context error:&requestError];
    
    if (!request) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:[self errorDomain]
                                         code:DFGWaterGaugeFinderErrorUnableToBuildRequest
                                     userInfo:nil];
        }
        
        return NO;
    }
    
    id<DFGWaterGaugeFinderDelegateProtocol> delegate = [context delegate];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:operationQueue
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
                               if ([(NSHTTPURLResponse*)response statusCode] != 200) {
                                   if ([delegate respondsToSelector:@selector(gaugeFinder:didFailToRetrieveGaugesWithContext:error:)]) {
                                       dispatch_sync(dispatch_get_main_queue(), ^() {
                                           [delegate gaugeFinder:self didFailToRetrieveGaugesWithContext:context error:error];
                                       });
                                       
                                       return;
                                   }
                               }
                               
                               // Handle general request errors.  Pass the error along
                               // to the delegate.
                               if (error) {
                                   // Pass back height failures for all gages.
                                   if ([delegate respondsToSelector:@selector(gaugeFinder:didFailToRetrieveGaugesWithContext:error:)]) { 
                                           dispatch_sync(dispatch_get_main_queue(), ^() {
                                           [delegate gaugeFinder:self
                              didFailToRetrieveGaugesWithContext:context
                                                           error:error];
                                           });
                                   }
                                   
                                   return;
                               }
                               
                               // Parse the response data into a group of readings.
                               NSError* parseError;
                               NSArray* gauges = [responseParser parseResponse:response
                                                                      withData:data
                                                                       context:context
                                                                         error:&parseError];
                               
                               
                               // Handle failure to parse the response data.
                               if (gauges == nil) {
                                   if ([delegate respondsToSelector:@selector(gaugeFinder:didFailToRetrieveGaugesWithContext:error:)]) {
                                       dispatch_sync(dispatch_get_main_queue(), ^() {
                                           [delegate gaugeFinder:self
                              didFailToRetrieveGaugesWithContext:context
                                                           error:parseError];
                                       });

                                   }
                                   return;
                               }
                               
                               if ([delegate respondsToSelector:@selector(gaugeFinder:didRetrieveGauges:withContext:)]) {
                                   dispatch_sync(dispatch_get_main_queue(), ^() {
                                       [delegate gaugeFinder:self
                                           didRetrieveGauges:gauges
                                                 withContext:context];
                                   });
                               }
                           }];
    
    return YES;
}

#pragma mark -
#pragma mark DFGError methods

- (NSString*)errorDomain
{
    return @"DFGWaterGaugeFinderErrors";
}


@end
