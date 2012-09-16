//
//  DFGWaterGaugeAPIDetailRetriever.h
//  DFGWater
//
//  Created by Brian DeShong on 9/15/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeDetailRetrieverProtocol.h"

@interface DFGWaterGaugeAPIDetailRetriever : NSObject <DFGWaterGaugeDetailRetrieverProtocol>

- (id)initWithRequestBuilder:(id<DFGWaterGaugeDetailRequestBuilderProtocol>)theRequestBuilder
              responseParser:(id<DFGWaterGaugeDetailResponseParserProtocol>)theResponseParser;

@end
