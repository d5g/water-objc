//
//  DFGWaterGaugeFinderAPIDataInterpreter.m
//  DFGWater
//
//  Created by Brian DeShong on 5/28/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeFinderAPIDataInterpreter.h"

@implementation DFGWaterGaugeFinderAPIDataInterpreter

- (NSString*)extractGaugeID:(NSDictionary*)gauge
{
    return [gauge objectForKey:@"id"];
}

- (NSString*)extractName:(NSDictionary*)gauge
{
    if ([(NSString*)[gauge objectForKey:@"agency"] isEqualToString:@"USGS"]) {
        return [gauge objectForKey:@"usgs_name"];
    }
    
    return nil;
}

- (CLLocationCoordinate2D)extractCoordinate:(NSDictionary*)gauge
{
    NSArray* loc = [[gauge objectForKey:@"location"] objectForKey:@"coordinate"];
    
    return CLLocationCoordinate2DMake([[loc objectAtIndex:0] doubleValue], [[loc objectAtIndex:1] doubleValue]);
}

- (NSString*)extractAgency:(NSDictionary*)gauge
{
    return [gauge objectForKey:@"agency"];
}

- (NSString*)extractAgencySlug:(NSDictionary*)gauge
{
    return [gauge objectForKey:@"agency_slug"];
}

- (NSString*)extractAgencyGaugeID:(NSDictionary*)gauge
{
    return [gauge objectForKey:@"agency_gauge_id"];
}

- (NSString*)extractStateCode:(NSDictionary*)gauge
{
    return [gauge objectForKey:@"state_code"];
}

- (NSString*)extractCountyCode:(NSDictionary*)gauge
{
    return [gauge objectForKey:@"county_code"];
}

@end
