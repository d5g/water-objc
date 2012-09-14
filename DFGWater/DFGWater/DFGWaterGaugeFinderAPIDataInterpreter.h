//
//  DFGWaterGaugeFinderAPIDataInterpreter.h
//  DFGWater
//
//  Created by Brian DeShong on 5/28/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DFGWaterGaugeFinderAPIDataInterpreter : NSObject

- (NSString*)extractGaugeID:(NSDictionary*)gauge;
- (NSString*)extractName:(NSDictionary*)gauge;
- (CLLocationCoordinate2D)extractCoordinate:(NSDictionary*)gauge;
- (NSString*)extractAgency:(NSDictionary*)gauge;
- (NSString*)extractAgencySlug:(NSDictionary*)gauge;
- (NSString*)extractAgencyGaugeID:(NSDictionary*)gauge;
- (NSString*)extractStateCode:(NSDictionary*)gauge;
- (NSString*)extractCountyCode:(NSDictionary*)gauge;

@end
