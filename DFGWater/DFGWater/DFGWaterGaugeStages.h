//
//  DFGWaterGaugeStages.h
//  DFGWater
//
//  Created by Brian DeShong on 12/3/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFGWaterGaugeStage;

@interface DFGWaterGaugeStages : NSObject

- (BOOL)hasStage;

@property (nonatomic, strong) DFGWaterGaugeStage* action;
@property (nonatomic, strong) DFGWaterGaugeStage* flood;
@property (nonatomic, strong) DFGWaterGaugeStage* moderate;
@property (nonatomic, strong) DFGWaterGaugeStage* major;

@end
