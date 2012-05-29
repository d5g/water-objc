//
//  DFGWaterGaugeFinderAPIDataInterpreter.h
//  DFGWater
//
//  Created by Brian DeShong on 5/28/12.
//  Copyright (c) 2012 Half Off Depot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DFGWaterGaugeFinderAPIDataInterpreter : NSObject

- (NSString*)extractGaugeID:(NSDictionary*)gauge;
- (NSString*)extractName:(NSDictionary*)gauge;
- (CLLocationCoordinate2D)extractCoordinate:(NSDictionary*)gauge;

@end
