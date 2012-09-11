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
@synthesize agency;
@synthesize agencySlug;
@synthesize stateCode;
@synthesize countyCode;
@synthesize hydrologicUnitCode;

+ (id)gaugeWithID:(NSString*)theGaugeID
          name:(NSString*)theName
{
    return [[self alloc] initWithGaugeID:theGaugeID
                                    name:theName
                      locationCoordinate:CLLocationCoordinate2DMake(0.0, 0.0)
                                  agency:nil
                              agencySlug:nil
                               stateCode:nil
                              countyCode:nil 
                      hydrologicUnitCode:nil];
}

- (id)initWithGaugeID:(NSString*)theGaugeID
                 name:(NSString*)theName
   locationCoordinate:(CLLocationCoordinate2D)theLocationCoordinate
               agency:(NSString*)theAgency
           agencySlug:(NSString*)theAgencySlug
            stateCode:(NSString*)theStateCode
           countyCode:(NSString*)theCountyCode
   hydrologicUnitCode:(NSString*)theHydrologicUnitCode
{
    self = [super init];
    
    if (self) {
        gaugeID = [theGaugeID copy];
        name = [theName copy];
        locationCoordinate = theLocationCoordinate;
        agency = [theAgency copy];
        agencySlug = [theAgencySlug copy];
        stateCode = [theStateCode copy];
        countyCode = [theCountyCode copy];
        hydrologicUnitCode = [theHydrologicUnitCode copy];
    }
    
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"gauge id = %@; name = %@; location = %f , %f; agency = %@; agency slug = %@; state code = %@; county code = %@; huc code = %@", gaugeID, name, locationCoordinate.latitude, locationCoordinate.longitude, agency, agencySlug, stateCode, countyCode, hydrologicUnitCode];
}

@end
