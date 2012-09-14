//
//  DFGWaterGauge.h
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface DFGWaterGauge : NSObject

@property (nonatomic, copy) NSString* gaugeID;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic, copy) NSString* agency;
@property (nonatomic, copy) NSString* agencySlug;
@property (nonatomic, copy) NSString* stateCode;
@property (nonatomic, copy) NSString* countyCode;
@property (nonatomic, copy) NSString* hydrologicUnitCode;

@end
