//
//  DFGWaterGaugeDataRetrieverDelegateProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 12/24/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeDataRetrieverProtocol.h"

@class DFGWaterGaugeDataRequestParameters;
@class DFGWaterGauge;

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
                  forGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Retrieved precipitation reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didRetrievePrecipitationReadings:(NSArray*)theReadings
                  forGauge:(DFGWaterGauge*)theGauge
             forParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Retrieved discharge reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didRetrieveDischargeReadings:(NSArray*)theReadings
                  forGauge:(DFGWaterGauge*)theGauge
             forParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Failed to retrieve height readings(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didFailToRetrieveHeightReadingsForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
                     error:(NSError*)theError;

// Failed to retrieve precipitation reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didFailToRetrievePrecipitationReadingsForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
                     error:(NSError*)theError;

// Failed to retrieve discharge reading(s).
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
didFailToRetrieveDischargeReadingsForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams
                     error:(NSError*)theError;

// Height reading(s) not available.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
heightReadingsNotAvailableForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Precipitation reading(s) not available.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
precipitationReadingsNotAvailableForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

// Discharge reading(s) not available.
- (void)gaugeDataRetriever:(id<DFGWaterGaugeDataRetrieverProtocol>)theRetriever
dischargeReadingsNotAvailableForGauge:(DFGWaterGauge*)theGauge
            withParameters:(DFGWaterGaugeDataRequestParameters*)theParams;

@end
