//
//  DFGWaterGaugeDataFinderDelegateProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 5/27/12.
//  Copyright (c) 2012 Half Off Depot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeFinderProtocol.h"

@class DFGWaterGaugeFinderContext;

@protocol DFGWaterGaugeFinderDelegateProtocol <NSObject>

// Will retrieve gauges.
- (void)gaugeFinder:(id<DFGWaterGaugeFinderProtocol>)theFinder
willRetrieveGaugesWithContext:(DFGWaterGaugeFinderContext*)theContext;

// Retrieved gauges.
- (void)gaugeFinder:(id<DFGWaterGaugeFinderProtocol>)theFinder
  didRetrieveGauges:(NSArray*)theGauges
        withContext:(DFGWaterGaugeFinderContext*)theContext;

// Failed to retrieve gauges.
- (void)gaugeFinder:(id<DFGWaterGaugeFinderProtocol>)theFinder
didFailToRetrieveGaugesWithContext:(DFGWaterGaugeFinderContext*)theContext
              error:(NSError*)theError;

@end
