//
//  DFGWaterGaugeDataAdder.h
//  DFGWater
//
//  Created by Brian DeShong on 9/15/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFGWaterGauge;

@interface DFGWaterGaugeDataAdder : NSObject

- (BOOL)addData:(NSDictionary*)dict toGauge:(DFGWaterGauge*)gauge;

@end
