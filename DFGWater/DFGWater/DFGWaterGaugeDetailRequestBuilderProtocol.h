//
//  DFGWaterGaugeDetailRequestBuilderProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 9/13/12.
//  Copyright (c) 2012 Half Off Depot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFGWaterGauge;

@protocol DFGWaterGaugeDetailRequestBuilderProtocol <NSObject>

- (NSURLRequest*)buildWithGauge:(DFGWaterGauge*)gauge;

@end
