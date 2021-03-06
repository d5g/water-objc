//
//  DFGWaterGaugeMultiDetailRequestBuilderProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 5/1/13.
//  Copyright (c) 2013 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kDFGWaterGaugeMultiDetailLevelBasic = 1
} DFGWaterGaugeMultiDetailLevel;

@protocol DFGWaterGaugeMultiDetailRequestBuilderProtocol <NSObject>

- (NSURLRequest*)buildWithGauges:(NSArray*)gauges
                     detailLevel:(DFGWaterGaugeMultiDetailLevel)detailLevel;

@end
