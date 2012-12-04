//
//  DFGWaterGaugeStage.h
//  DFGWater
//
//  Created by Brian DeShong on 12/3/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFGWaterGaugeStage : NSObject

- (NSDecimalNumber*)valueAsDecimalNumber;

@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) float value;
@property (nonatomic, copy) NSString* unit;

@end
