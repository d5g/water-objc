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

- (NSString*)description
{
    return [NSString stringWithFormat:@"gauge id = %@; name = %@; location = %f , %f; agency = %@; agency slug = %@; state code = %@; county code = %@; huc code = %@", gaugeID, name, locationCoordinate.latitude, locationCoordinate.longitude, agency, agencySlug, stateCode, countyCode, hydrologicUnitCode];
}

@end
