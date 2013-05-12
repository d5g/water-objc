//
//  DFGWaterGaugeMultiDetailRetrieverProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 5/1/13.
//  Copyright (c) 2013 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeMultiDetailRequestBuilderProtocol.h"
#import "DFGWaterGaugeMultiDetailResponseParserProtocol.h"

typedef void (^DFGWaterGaugeMultiDetailRetrieverSuccessBlock)(NSArray* theGauges, DFGWaterGaugeMultiDetailLevel detailLevel);
typedef void (^DFGWaterGaugeMultiDetailRetrieverErrorBlock)(NSURLResponse* response, NSData *data, NSString* errorMessage);

@protocol DFGWaterGaugeMultiDetailRetrieverProtocol <NSObject>

- (BOOL)retrieveForGauges:(NSArray*)gauges
              detailLevel:(DFGWaterGaugeMultiDetailLevel)detailLevel
             successBlock:(DFGWaterGaugeMultiDetailRetrieverSuccessBlock)theSuccessBlock
               errorBlock:(DFGWaterGaugeMultiDetailRetrieverErrorBlock)theErrorBlock;

@property (nonatomic, strong) id<DFGWaterGaugeMultiDetailRequestBuilderProtocol> requestBuilder;
@property (nonatomic, strong) id<DFGWaterGaugeMultiDetailResponseParserProtocol> responseParser;

@end
