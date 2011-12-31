//
//  DFGWaterGaugeDataRetrieverProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 12/23/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DFGWaterGaugeDataRetrieverErrorInadequateParameters = 1,
    DFGWaterGaugeDataRetrieverErrorUnableToBuildRequest,
    DFGWaterGaugeDataRetrieverErrorUnableToParseResponse,
} DFGWaterGaugeDataRetrieverError;

@class DFGWaterGaugeDataRequestParameters;

@protocol DFGWaterGaugeDataRetrieverProtocol <NSObject>

// Retrieve data with the given parameters.
- (BOOL)retrieveData:(DFGWaterGaugeDataRequestParameters*)params
               error:(NSError**)error;

@end
