//
//  DFGWaterGaugeForecast.h
//  DFGWater
//
//  Created by Brian DeShong on 12/7/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFGWaterReading;

@interface DFGWaterGaugeForecast : NSObject

@property (nonatomic, strong) NSDate* issued;
@property (nonatomic, strong) DFGWaterReading* highestReading;

@end
