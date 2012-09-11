//
//  DFGWaterGaugeFinderAPIDataInterpreter.m
//  DFGWater
//
//  Created by Brian DeShong on 5/28/12.
//  Copyright (c) 2012 Half Off Depot. All rights reserved.
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

@end
