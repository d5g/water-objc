//
//  DFGGaugesByLocationRetriever.h
//  FloodWatch
//
//  Created by Brian DeShong on 8/9/12.
//  Copyright (c) 2012 Brian DeShong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeFinderProtocol.h"
#import "DFGWaterGaugeFinderRequestBuilderProtocol.h"
#import "DFGWaterGaugeFinderResponseParserProtocol.h"

@interface DFGWaterGaugeAPIFinder : NSObject <DFGWaterGaugeFinderProtocol>

- (id)initWithRequestBuilder:(id<DFGWaterGaugeFinderRequestBuilderProtocol>)theRequestBuilder
              responseParser:(id<DFGWaterGaugeFinderResponseParserProtocol>)theResponseParser;

@property (nonatomic, strong) id<DFGWaterGaugeFinderRequestBuilderProtocol> requestBuilder;
@property (nonatomic, strong) id<DFGWaterGaugeFinderResponseParserProtocol> responseParser;

@end