//
//  DFGWaterUSGSIVJSONResponseParser.m
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 Half Off Depot. All rights reserved.
//

#import "DFGWaterUSGSIVJSONResponseParser.h"
#import "DFGWaterGauge.h"

@implementation DFGWaterUSGSIVJSONResponseParser

- (NSArray*)parseResponse:(NSURLResponse*)theResponse
                 withData:(NSData*)theData
               parameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
    // parse JSON into dictionary
    
    // foreach timeSeries
    //
    //     sourceInfo.siteName => name
    //     sourceInfo.siteCode.value => gaugeID
    //     sourceInfo.geoLocation.geogLocation.latitude, longitude => location
    //     sourceInfo.siteProperty.stateCode, countyCode, hucCd => stateCode, countrycode, hydrologicUnitCode
    //
    //     variable.variableCode.value => 00060, 00065, etc.
    //     variable.variableName
    //     variable.variableDescription
    //     variable.unitDescription
    //
    //     variable.values ...array with .value, .dateTime
    
    NSError* jsonParseError;
    NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonParseError];
    
    NSMutableArray* gaugeData = [NSMutableArray arrayWithCapacity:1];
    
    NSArray* timeSeries = [[dict objectForKey:@"value"] objectForKey:@"timeSeries"];
    
    for (NSDictionary* seriesData in timeSeries) {
        NSDictionary* sourceInfo = [seriesData objectForKey:@"sourceInfo"];
        NSDictionary* geogLocation = [[sourceInfo objectForKey:@"geoLocation"] objectForKey:@"geogLocation"];
        NSArray* siteProperty = [sourceInfo objectForKey:@"siteProperty"];

        NSString* stateCode;
        NSString* countyCode;
        NSString* hucCode;
        
        for (NSDictionary* theSiteProperty in siteProperty) {
            if ([[theSiteProperty objectForKey:@"name"] isEqualToString:@"stateCd"]) {
                stateCode = [theSiteProperty objectForKey:@"value"];
            } else if ([[theSiteProperty objectForKey:@"name"] isEqualToString:@"countyCd"]) {
                countyCode = [theSiteProperty objectForKey:@"value"];
            } else if ([[theSiteProperty objectForKey:@"name"] isEqualToString:@"hucCd"]) {
                hucCode = [theSiteProperty objectForKey:@"value"];
            }
        }
        
        CLLocationDegrees latitude = [[geogLocation objectForKey:@"latitude"] doubleValue];
        CLLocationDegrees longitude = [[geogLocation objectForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
        
        NSDictionary* siteCodeData = [[sourceInfo objectForKey:@"siteCode"] objectAtIndex:0];

        DFGWaterGauge* gauge = [[DFGWaterGauge alloc] initWithGaugeID:[siteCodeData objectForKey:@"value"]
                                                                 name:[sourceInfo objectForKey:@"siteName"]
                                                   locationCoordinate:location
                                                           agencyCode:[siteCodeData objectForKey:@"agencyCode"]
                                                            stateCode:stateCode
                                                           countyCode:countyCode
                                                   hydrologicUnitCode:hucCode];
        
        // TODO: parse the values into a usable object
        
        [gaugeData addObject:gauge];
    }
    
    return [NSArray arrayWithArray:gaugeData];
}

@end
