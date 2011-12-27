//
//  DFGWaterUSGSGaugeDataRetriever.h
//  DFGWater
//
//  Created by Brian DeShong on 12/24/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeDataRetrieverProtocol.h"
#import "DFGError.h"
#import "DFGWaterServiceRequestBuilderProtocol.h"
#import "DFGWaterServiceResponseParserProtocol.h"

@interface DFGWaterUSGSGaugeDataRetriever : NSObject <DFGWaterGaugeDataRetrieverProtocol, DFGError>

- (id)initWithOperationQueue:(NSOperationQueue*)theOperationQueue
              requestBuilder:(id<DFGWaterServiceRequestBuilderProtocol>)theRequestBuilder
              responseParser:(id<DFGWaterServiceResponseParserProtocol>)theResponseParser;

@property (nonatomic, readonly, strong) NSOperationQueue* operationQueue;
@property (nonatomic, readonly, strong) id<DFGWaterServiceRequestBuilderProtocol> requestBuilder;
@property (nonatomic, readonly, strong) id<DFGWaterServiceResponseParserProtocol> responseParser;

@end
