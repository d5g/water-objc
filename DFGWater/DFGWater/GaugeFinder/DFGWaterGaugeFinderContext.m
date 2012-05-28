//
//  DFGWaterGaugeFinderContext.m
//  DFGWater
//
//  Created by Brian DeShong on 5/27/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeFinderContext.h"

@implementation DFGWaterGaugeFinderContext

@synthesize coordinate;
@synthesize radiusInMiles;
@synthesize delegate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate
           radiusInMiles:(float)theRadiusInMiles
                delegate:(id<DFGWaterGaugeDataFinderDelegateProtocol>)theDelegate
{
    self = [super init];
    
    if (self) {
        coordinate = theCoordinate;
        radiusInMiles = theRadiusInMiles;
        delegate = theDelegate;
    }
    
    return self;
}

@end
