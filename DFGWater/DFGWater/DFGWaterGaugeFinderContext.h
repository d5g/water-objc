//
//  DFGWaterGaugeFinderContext.h
//  DFGWater
//
//  Created by Brian DeShong on 5/27/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DFGWaterGaugeFinderDelegateProtocol.h"

@interface DFGWaterGaugeFinderContext : NSObject

- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate
           radiusInMiles:(float)theRadiusInMiles
                delegate:(id<DFGWaterGaugeFinderDelegateProtocol>)theDelegate;

@property (nonatomic, readonly, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, assign) float radiusInMiles;
@property (nonatomic, readonly, assign) id<DFGWaterGaugeFinderDelegateProtocol> delegate;

@end
