//
//  DFGWaterGaugeFinderAPI.h
//  DFGWater
//
//  Created by Brian DeShong on 5/27/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGError.h"
#import "DFGWaterGaugeFinderProtocol.h"
#import "DFGWaterGaugeFinderRequestBuilderProtocol.h"
#import "DFGWaterGaugeFinderResponseParserProtocol.h"

@interface DFGWaterGaugeFinderAPI : NSObject <DFGWaterGaugeFinderProtocol, DFGError>

- (id)initWithOperationQueue:(NSOperationQueue*)theOperationQueue
              requestBuilder:(id<DFGWaterGaugeFinderRequestBuilderProtocol>)theRequestBuilder
              responseParser:(id<DFGWaterGaugeFinderResponseParserProtocol>)theResponseParser;

@property (nonatomic, readonly, strong) NSOperationQueue* operationQueue;
@property (nonatomic, readonly, strong) id<DFGWaterGaugeFinderRequestBuilderProtocol> requestBuilder;
@property (nonatomic, readonly, strong) id<DFGWaterGaugeFinderResponseParserProtocol> responseParser;

@end
