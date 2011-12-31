//
//  DFGWaterUSGSIVIntegrationTests.m
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 Half Off Depot. All rights reserved.
//

#import "DFGWaterUSGSIVIntegrationTests.h"

@implementation DFGWaterUSGSIVIntegrationTests

- (void)setUp
{
    willRetrieveCalled = NO;
    didRetrieveHeightReadings = NO;
    didRetrievePrecipitationReadings = NO;
    didRetrieveDischargeReadings = NO;
}

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
    
    /**
     DFGWaterGaugeDataRequestParameters* params = [[DFGWaterGaugeDataRequestParameters alloc] initWithGauges:[NSArray arrayWithObject:gauge] numDaysAgo:1 sinceDate:nil endDate:nil height:YES precipitation:YES discharge:YES delegate:self];
     **/
    
    NSOperationQueue* operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue setMaxConcurrentOperationCount:1];
    
    DFGWaterUSGSIVJSONRequestBuilder* requestBuilder = [[DFGWaterUSGSIVJSONRequestBuilder alloc] init];
    DFGWaterUSGSIVJSONResponseParser* responseParser = [[DFGWaterUSGSIVJSONResponseParser alloc] init];
    
    DFGWaterUSGSGaugeDataRetriever* retriever = [[DFGWaterUSGSGaugeDataRetriever alloc] initWithOperationQueue:operationQueue
                                                                                                requestBuilder:requestBuilder
                                                                                                responseParser:responseParser];
    
    NSError* error;
    NSLog(@"retrieving on thread %@", [NSThread currentThread]);
    BOOL retrieving = [retriever retrieveData:params error:&error];
    
    STAssertTrue(retrieving, @"expected retrieval to have started");
    
    sleep(5);
    
    STAssertTrue(willRetrieveCalled, @"expected willRetrieveCalled to be true");
    STAssertTrue(didRetrieveHeightReadings, @"expected didRetrieveHeightReadings to be called");
    STAssertTrue(didRetrievePrecipitationReadings, @"expected didRetrievePrecipitationReadings to be called");
    STAssertTrue(didRetrieveDischargeReadings, @"expected didRetrieveDischargeReadings to be called");
}

// Will retrieve data for parameters.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
willRetrieveDataForParameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
    willRetrieveCalled = YES;
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
    didRetrieveHeightReadings = YES;
}

// Retrieved precipitation reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didRetrievePrecipitationReadings:(NSArray*)theReadings
                  forGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
    didRetrievePrecipitationReadings = YES;
}

// Retrieved discharge reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didRetrieveDischargeReadings:(NSArray*)theReadings
                  forGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
    didRetrieveDischargeReadings = YES;
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
