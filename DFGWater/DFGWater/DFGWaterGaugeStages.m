//
//  DFGWaterGaugeStages.m
//  DFGWater
//
//  Created by Brian DeShong on 12/3/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeStages.h"

@implementation DFGWaterGaugeStages

@synthesize action;
@synthesize flood;
@synthesize moderate;
@synthesize major;

- (BOOL)hasStage
{
    return action != nil || flood != nil || moderate != nil || major != nil;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"%@; %@; %@; %@", action, flood, moderate, major];
}
@end
