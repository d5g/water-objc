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

- (id)initWithGaugeID:(NSString*)theGaugeID
                 name:(NSString*)theName
   locationCoordinate:(CLLocationCoordinate2D)theLocationCoordinate
           agencyCode:(NSString*)theAgencyCode
            stateCode:(NSString*)theStateCode
           countyCode:(NSString*)theCountyCode
   hydrologicUnitCode:(NSString*)theHydrologicUnitCode;

@property (nonatomic, copy, readonly) NSString* gaugeID;
@property (nonatomic, copy, readonly) NSString* name;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic, copy, readonly) NSString* agencyCode;
@property (nonatomic, copy, readonly) NSString* stateCode;
@property (nonatomic, copy, readonly) NSString* countyCode;
@property (nonatomic, copy, readonly) NSString* hydrologicUnitCode;

@end
