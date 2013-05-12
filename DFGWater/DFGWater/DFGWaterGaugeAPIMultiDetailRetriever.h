//
//  DFGWaterGaugeAPIMultiDetailRetriever.h
//  DFGWater
//
//  Created by Brian DeShong on 5/12/13.
//  Copyright (c) 2013 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeMultiDetailRequestBuilderProtocol.h"
#import "DFGWaterGaugeMultiDetailResponseParserProtocol.h"
#import "DFGWaterGaugeMultiDetailRetrieverProtocol.h"

@interface DFGWaterGaugeAPIMultiDetailRetriever : NSObject <DFGWaterGaugeMultiDetailRetrieverProtocol>

- (id)initWithRequestBuilder:(id<DFGWaterGaugeMultiDetailRequestBuilderProtocol>)theRequestBuilder
           theResponseParser:(id<DFGWaterGaugeMultiDetailResponseParserProtocol>)theResponseParser;

- (BOOL)retrieveForGauges:(NSArray*)gauges
              detailLevel:(DFGWaterGaugeMultiDetailLevel)detailLevel
             successBlock:(DFGWaterGaugeMultiDetailRetrieverSuccessBlock)theSuccessBlock
               errorBlock:(DFGWaterGaugeMultiDetailRetrieverErrorBlock)theErrorBlock;

@end
