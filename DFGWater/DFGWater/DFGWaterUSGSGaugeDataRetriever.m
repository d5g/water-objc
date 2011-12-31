//
//  DFGWaterUSGSGaugeDataRetriever.m
//  DFGWater
//
//  Created by Brian DeShong on 12/24/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterUSGSGaugeDataRetriever.h"
#import "DFGWaterReadingGroup.h"
#import "DFGWaterGaugeDataRequestParameters.h"
#import "DFGWaterGaugeDataRetrieverDelegateProtocol.h"

@interface DFGWaterUSGSGaugeDataRetriever ()

- (void)notifyDelegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)delegate
               ofError:(NSError*)error
            withParams:(DFGWaterGaugeDataRequestParameters*)params;

@end

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
    
    id<DFGWaterGaugeDataRetrieverDelegateProtocol> delegate = [params delegate];
    
    // Tell delegate that we're aboue to fire off a request.
    if ([delegate respondsToSelector:@selector(gaugeDataRetriever:willRetrieveDataForParameters:)]) {
        [delegate gaugeDataRetriever:self willRetrieveDataForParameters:params];
    }
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:operationQueue
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
                               if ([(NSHTTPURLResponse*)response statusCode] != 200) {
                                   if ([delegate respondsToSelector:@selector(gaugeDataRetriever:didFailToRetrieveDataForParameters:)]) {
                                       [delegate gaugeDataRetriever:self didFailToRetrieveDataForParameters:params];
                                       return;
                                   }
                               }
                               
                               // Handle general request errors.  Pass the error along
                               // to the delegate.
                               if (error) {
                                   [self notifyDelegate:delegate
                                                ofError:error
                                             withParams:params];
                                   return;
                               }
                               
                               // Parse the response data into a group of readings.
                               NSError* parseError;
                               DFGWaterReadingGroup* readingGroup = [responseParser parseResponse:response
                                                                                         withData:data
                                                                                       parameters:params
                                                                                            error:&parseError];
                               
                               
                               NSLog(@"thread = %@; reading group = %@", [NSThread currentThread], readingGroup);
                               
                               // Handle failure to parse the response data.
                               if (readingGroup == nil) {
                                   [self notifyDelegate:delegate
                                                ofError:parseError
                                             withParams:params];
                                   return;
                               }
                               
                               NSArray* readings;
                               
                               for (DFGWaterGauge* gauge in [params gauges]) {
                                   //
                                   // Pass back height readings
                                   //
                                   readings = [readingGroup gauge:gauge readingsOfType:DFGWaterReadingGroupTypeHeight];
                                   
                                   // Pass back what we got, or indicate not available if none are present.
                                   if (readings) {
                                       if ([delegate respondsToSelector:@selector(gaugeDataRetriever:didRetrieveHeightReadings:forGauge:withParameters:)]) {
                                           [delegate gaugeDataRetriever:self
                                              didRetrieveHeightReadings:readings
                                                               forGauge:gauge
                                                         withParameters:params];
                                       }
                                   } else {
                                       if ([delegate respondsToSelector:@selector(gaugeDataRetriever:heightReadingsNotAvailableForGauge:withParameters:)]) {
                                           [delegate gaugeDataRetriever:self
                                     heightReadingsNotAvailableForGauge:gauge
                                                         withParameters:params];
                                       }
                                   }
                                   
                                   //
                                   // Pass back precipitation readings
                                   //
                                   readings = [readingGroup gauge:gauge readingsOfType:DFGWaterReadingGroupTypePrecipitation];
                                   
                                   // Pass back what we got, or indicate not available if none are present.
                                   if (readings) {
                                       if ([delegate respondsToSelector:@selector(gaugeDataRetriever:didRetrievePrecipitationReadings:forGauge:withParameters:)]) {
                                           [delegate gaugeDataRetriever:self
                                       didRetrievePrecipitationReadings:readings
                                                               forGauge:gauge
                                                         withParameters:params];
                                       }
                                   } else {
                                       if ([delegate respondsToSelector:@selector(gaugeDataRetriever:heightReadingsNotAvailableForGauge:withParameters:)]) {
                                           [delegate gaugeDataRetriever:self
                                     heightReadingsNotAvailableForGauge:gauge
                                                         withParameters:params];
                                       }
                                   }
                                   
                                   //
                                   // Pass back discharge readings
                                   //
                                   readings = [readingGroup gauge:gauge readingsOfType:DFGWaterReadingGroupTypeDischarge];
                                   
                                   // Pass back what we got, or indicate not available if none are present.
                                   if (readings) {
                                       if ([delegate respondsToSelector:@selector(gaugeDataRetriever:didRetrieveDischargeReadings:forGauge:withParameters:)]) {
                                           [delegate gaugeDataRetriever:self
                                           didRetrieveDischargeReadings:readings
                                                               forGauge:gauge
                                                         withParameters:params];
                                       }
                                   } else {
                                       if ([delegate respondsToSelector:@selector(gaugeDataRetriever:dischargeReadingsNotAvailableForGauge:withParameters:)]) {
                                           [delegate gaugeDataRetriever:self
                                  dischargeReadingsNotAvailableForGauge:gauge
                                                         withParameters:params];
                                       }
                                   }
                               }
                           }];
    
    return YES;
}

#pragma mark -
#pragma mark DFGError methods

- (NSString*)errorDomain
{
    return @"DFGWaterUSGSGaugeDataRetrieverErrors";
}

#pragma mark -
#pragma mark Private methods

- (void)notifyDelegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)delegate
               ofError:(NSError*)error
            withParams:(DFGWaterGaugeDataRequestParameters*)params
{
    // Pass back height failures for all gages.
    if ([params height] && [delegate respondsToSelector:@selector(gaugeDataRetriever:didFailToRetrieveHeightReadingsForGauge:withParameters:error:)]) { 
        for (DFGWaterGauge* gauge in [params gauges]) {
            [delegate gaugeDataRetriever:self
 didFailToRetrieveHeightReadingsForGauge:gauge
                          withParameters:params
                                   error:error];
        }
    }
    
    // Pass back precipitation failures for all gages.
    if ([params precipitation] && [delegate respondsToSelector:@selector(gaugeDataRetriever:didFailToRetrievePrecipitationReadingsForGauge:withParameters:error:)]) { 
        for (DFGWaterGauge* gauge in [params gauges]) {
            [delegate gaugeDataRetriever:self
didFailToRetrievePrecipitationReadingsForGauge:gauge
                          withParameters:params
                                   error:error];
        }
    }
    
    // Pass back discharge failures for all gages.
    if ([params discharge] && [delegate respondsToSelector:@selector(gaugeDataRetriever:didFailToRetrieveDischargeReadingsForGauge:withParameters:error:)]) { 
        for (DFGWaterGauge* gauge in [params gauges]) {
            [delegate gaugeDataRetriever:self
didFailToRetrieveDischargeReadingsForGauge:gauge
                          withParameters:params
                                   error:error];
        }
    }
}

@end
