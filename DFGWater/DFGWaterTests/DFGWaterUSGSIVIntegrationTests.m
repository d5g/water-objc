//
//  DFGWaterUSGSIVIntegrationTests.m
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 Half Off Depot. All rights reserved.
//

#import "DFGWaterUSGSIVIntegrationTests.h"

@implementation DFGWaterUSGSIVIntegrationTests

- (void)testSweetwaterCreekHeightPrecipitationDischarge
{
    DFGWaterGauge* gauge = [[DFGWaterGauge alloc] initWithGaugeID:@"02336910"
                                                             name:nil
                                               locationCoordinate:CLLocationCoordinate2DMake(0.0, 0.0)
                                                       agencyCode:nil
                                                        stateCode:nil
                                                       countyCode:nil
                                               hydrologicUnitCode:nil];
    
    DFGWaterGaugeDataRequestParameters* params =
    [[DFGWaterGaugeDataRequestParameters alloc] initWithGaugeForAllMostRecentReadings:gauge
                                                                             delegate:self];
    
    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:1];
    
    DFGWaterUSGSIVJSONRequestBuilder* requestBuilder = [[DFGWaterUSGSIVJSONRequestBuilder alloc] init];
    DFGWaterUSGSIVJSONResponseParser* responseParser = [[DFGWaterUSGSIVJSONResponseParser alloc] init];
    
    DFGWaterUSGSGaugeDataRetriever* retriever = [[DFGWaterUSGSGaugeDataRetriever alloc] initWithOperationQueue:operationQueue
                                                                                                requestBuilder:requestBuilder
                                                                                                responseParser:responseParser];

    NSError* error;
    BOOL retrieving = [retriever retrieveData:params error:&error];
    
    STAssertTrue(retrieving, @"expected retrieval to have started");
}

// Will retrieve data for parameters.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
willRetrieveDataForParameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
}

// Failed to retrieve data for parameters.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didFailToRetrieveDataForParameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
}

// Retrieved height reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
 didRetrieveHeightReadings:(NSArray*)theReadings
                  forGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
}

// Retrieved precipitation reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didRetrievePrecipitationReadings:(NSArray*)theReadings
                  forGauge:(DFGWaterGauge*)theGauge
             forParameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
}

// Retrieved discharge reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didRetrieveDischargeReadings:(NSArray*)theReadings
                  forGauge:(DFGWaterGauge*)theGauge
             forParameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
}

// Failed to retrieve height readings(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didFailToRetrieveHeightReadingsForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
                     error:(NSError*)theError
{
}

// Failed to retrieve precipitation reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didFailToRetrievePrecipitationReadingsForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
                     error:(NSError*)theError
{
}

// Failed to retrieve discharge reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didFailToRetrieveDischargeReadingsForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
                     error:(NSError*)theError
{
}

// Height reading(s) not available.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
heightReadingsNotAvailableForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
}

// Precipitation reading(s) not available.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
precipitationReadingsNotAvailableForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
}

// Discharge reading(s) not available.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
dischargeReadingsNotAvailableForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
}

@end
