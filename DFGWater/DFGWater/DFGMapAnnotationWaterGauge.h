//
//  DFGMapAnnotationWaterGauge.h
//  DFGWater
//
//  Created by Brian DeShong on 8/13/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class DFGWaterGauge;

@interface DFGMapAnnotationWaterGauge : NSObject <MKAnnotation>

- (id)initWithGauge:(DFGWaterGauge*)theGauge;

@property (nonatomic, strong) DFGWaterGauge* gauge;

@end
