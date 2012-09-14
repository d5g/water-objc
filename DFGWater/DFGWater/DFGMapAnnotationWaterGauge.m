//
//  DFGMapAnnotationWaterGauge.m
//  DFGWater
//
//  Created by Brian DeShong on 8/13/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGMapAnnotationWaterGauge.h"
#import "DFGWaterGauge.h"

@implementation DFGMapAnnotationWaterGauge

@synthesize gauge;

- (id)initWithGauge:(DFGWaterGauge*)theGauge
{
    if (self = [super init]) {
        [self setGauge:theGauge];
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    return [gauge locationCoordinate];
}

- (NSString*)title
{
    return [gauge name];
}

@end
