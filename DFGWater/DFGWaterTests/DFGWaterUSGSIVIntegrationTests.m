//
//  DFGWaterUSGSIVIntegrationTests.m
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
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

- (void)testSweetwaterCreekHeightPrecipitationDischargeLastReading
{
    DFGWaterGauge* gauge = [[DFGWaterGauge alloc] initWithGaugeID:@"02336910"
                                                             name:nil
                                               locationCoordinate:CLLocationCoordinate2DMake(0.0, 0.0)
                                                       agencySlug:nil
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
    NSLog(@"retrieving on thread %@", [NSThread currentThread]);
    BOOL retrieving = [retriever retrieveData:params error:&error];
    
    STAssertTrue(retrieving, @"expected retrieval to have started");
    
    sleep(5);
    
    STAssertTrue(willRetrieveCalled, @"expected willRetrieveCalled to be true");
    STAssertTrue(didRetrieveHeightReadings, @"expected didRetrieveHeightReadings to be called");
    STAssertTrue(didRetrievePrecipitationReadings, @"expected didRetrievePrecipitationReadings to be called");
    STAssertTrue(didRetrieveDischargeReadings, @"expected didRetrieveDischargeReadings to be called");
}

- (void)testSweetwaterCreekHeightPrecipitationDischargeOneDayAgo
{
    DFGWaterGauge* gauge = [[DFGWaterGauge alloc] initWithGaugeID:@"02336910"
                                                             name:nil
                                               locationCoordinate:CLLocationCoordinate2DMake(0.0, 0.0)
                                                           agency:nil
                                                       agencySlug:nil
                                                        stateCode:nil
                                                       countyCode:nil
                                               hydrologicUnitCode:nil];
    
     DFGWaterGaugeDataRequestParameters* params = [[DFGWaterGaugeDataRequestParameters alloc] initWithGauges:[NSArray arrayWithObject:gauge]
                                                                                                  numDaysAgo:1
                                                                                                   sinceDate:nil
                                                                                                     endDate:nil
                                                                                                      height:YES
                                                                                               precipitation:YES
                                                                                                   discharge:YES
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
    
    sleep(5);
    
    STAssertTrue(willRetrieveCalled, @"expected willRetrieveCalled to be true");
    STAssertTrue(didRetrieveHeightReadings, @"expected didRetrieveHeightReadings to be called");
    STAssertTrue(didRetrievePrecipitationReadings, @"expected didRetrievePrecipitationReadings to be called");
    STAssertTrue(didRetrieveDischargeReadings, @"expected didRetrieveDischargeReadings to be called");
}

- (void)testSweetwaterCreekHeightPrecipitationDischargeWithDateRange
{
    DFGWaterGauge* gauge = [[DFGWaterGauge alloc] initWithGaugeID:@"02336910"
                                                             name:nil
                                               locationCoordinate:CLLocationCoordinate2DMake(0.0, 0.0)
                                                           agency:nil
                                                       agencySlug:nil
                                                        stateCode:nil
                                                       countyCode:nil
                                               hydrologicUnitCode:nil];
    
    NSDate* sinceDate = [NSDate dateWithTimeIntervalSinceNow:-691200];
    NSDate* endDate = [NSDate dateWithTimeIntervalSinceNow:-86400];
    
    DFGWaterGaugeDataRequestParameters* params = [[DFGWaterGaugeDataRequestParameters alloc] initWithGauges:[NSArray arrayWithObject:gauge]
                                                                                                 numDaysAgo:0
                                                                                                  sinceDate:sinceDate
                                                                                                    endDate:endDate
                                                                                                     height:YES
                                                                                              precipitation:YES
                                                                                                  discharge:YES
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
