//
//  DFGWaterGaugeDataRetrieverDelegateProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 12/24/11.
//  Copyright (c) 2011 Half Off Depot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeDataRetrieverProtocol.h"

@class DFGWaterGaugeDataRequestParameters;

@protocol DFGWaterGaugeDataRetrieverDelegateProtocol <NSObject>

@optional

// Will retrieve data for parameters.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
willRetrieveDataForParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Failed to retrieve data for parameters.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didFailToRetrieveDataForParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Retrieved height reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
 didRetrieveHeightReadings:(NSArray*)theReadings
             forParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Retrieved precipitation reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didRetrievePrecipitationReadings:(NSArray*)theReadings
             forParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Retrieved discharge reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didRetrieveDischargeReadings:(NSArray*)theReadings
             forParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Failed to retrieve height readings(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didFailToRetrieveHeightReadingsForParameters:(DFGWaterGaugeDataRequestParameters*)theParams
                     error:(NSError*)theError;

// Failed to retrieve precipitation reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didFailToRetrievePrecipitationReadingsForParameters:(DFGWaterGaugeDataRequestParameters*)theParams
                     error:(NSError*)theError;

// Failed to retrieve discharge reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didFailToRetrieveDischargeReadingsForParameters:(DFGWaterGaugeDataRequestParameters*)theParams
                     error:(NSError*)theError;

// Height reading(s) not available.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
heightReadingsNotAvailableForParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Precipitation reading(s) not available.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
precipitationReadingsNotAvailableForParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Discharge reading(s) not available.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
dischargeReadingsNotAvailableForParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

@end
