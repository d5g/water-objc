//
//  DFGWaterGaugeDetailRetrieverProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 9/15/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeDetailRequestBuilderProtocol.h"
#import "DFGWaterGaugeDetailResponseParserProtocol.h"

@class DFGWaterGauge;

typedef void (^DFGWaterGaugeDetailRetrieverSuccessBlock)(DFGWaterGauge* theGauge);
typedef void (^DFGWaterGaugeDetailRetrieverErrorBlock)(NSURLResponse* response, NSData *data, NSString* errorMessage);

@protocol DFGWaterGaugeDetailRetrieverProtocol <NSObject>

- (BOOL)retrieveForGauge:(DFGWaterGauge*)gauge
            successBlock:(DFGWaterGaugeDetailRetrieverSuccessBlock)theSuccessBlock
              errorBlock:(DFGWaterGaugeDetailRetrieverErrorBlock)theErrorBlock;

@property (nonatomic, strong) id<DFGWaterGaugeDetailRequestBuilderProtocol> requestBuilder;
@property (nonatomic, strong) id<DFGWaterGaugeDetailResponseParserProtocol> responseParser;

@end
