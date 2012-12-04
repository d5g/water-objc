//
//  DFGWaterGaugeStage.m
//  DFGWater
//
//  Created by Brian DeShong on 12/3/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeStage.h"

@implementation DFGWaterGaugeStage

@synthesize name;
@synthesize value;

- (NSDecimalNumber*)valueAsDecimalNumber
{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSDecimalNumber* decimal = (NSDecimalNumber*)[formatter numberFromString:[NSString stringWithFormat:@"%.4f", value]];
    
    return decimal;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ = %.4f", name, value];
}

@end
