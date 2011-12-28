//
//  DFGWaterGauge.m
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGauge.h"

@implementation DFGWaterGauge

@synthesize gaugeID;
@synthesize name;
@synthesize locationCoordinate;
@synthesize agencyCode;
@synthesize stateCode;
@synthesize countyCode;
@synthesize hydrologicUnitCode;

- (id)initWithGaugeID:(NSString*)theGaugeID
                 name:(NSString*)theName
   locationCoordinate:(CLLocationCoordinate2D)theLocationCoordinate
           agencyCode:(NSString*)theAgencyCode
            stateCode:(NSString*)theStateCode
           countyCode:(NSString*)theCountyCode
   hydrologicUnitCode:(NSString*)theHydrologicUnitCode
{
    self = [super init];
    
    if (self) {
        gaugeID = [theGaugeID copy];
        name = [theName copy];
        locationCoordinate = theLocationCoordinate;
        agencyCode = [theAgencyCode copy];
        stateCode = [theStateCode copy];
        countyCode = [theCountyCode copy];
        hydrologicUnitCode = [theHydrologicUnitCode copy];
    }
    
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"gauge id = %@; name = %@; location = %d , %d; agency code = %@; state code = %@; county code = %@; huc code = %@", gaugeID, name, 0, 0, agencyCode, stateCode, countyCode, hydrologicUnitCode];
}

@end
