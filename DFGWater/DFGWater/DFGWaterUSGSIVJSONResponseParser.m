//
//  DFGWaterUSGSIVJSONResponseParser.m
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 Half Off Depot. All rights reserved.
//

#import "DFGWaterUSGSIVJSONResponseParser.h"
#import "DFGWaterGauge.h"
#import "DFGWaterReadingGroup.h"
#import "DFGWaterReading.h"

@implementation DFGWaterUSGSIVJSONResponseParser

- (DFGWaterReadingGroup*)parseResponse:(NSURLResponse*)theResponse
                              withData:(NSData*)theData
                            parameters:(DFGWaterGaugeDataRequestParameters*)theParams
                                 error:(NSError**)theError
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
    
    if ([theData length] == 0) {
        if (theError != NULL) {
            *theError = [NSError errorWithDomain:[self errorDomain]
                                         code:DFGWaterServiceResponseParserProtocolErrorNoDataToParse
                                     userInfo:nil];
        }
        
        return nil;
    }
    
    NSError* jsonParseError;
    NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonParseError];
    
    if (!dict) {
        if (theError != NULL) {
            *theError = [NSError errorWithDomain:[self errorDomain]
                                         code:DFGWaterServiceResponseParserProtocolErrorUnableToParseData
                                     userInfo:nil];
        }
        
        return nil;
    }
    
    NSArray* timeSeries = [[dict objectForKey:@"value"] objectForKey:@"timeSeries"];
    
    // Prepare the digest of our response data.
    DFGWaterReadingGroup* readingGroup = [[DFGWaterReadingGroup alloc] init];
    
    // Formatter for reading dates.
    NSDateFormatter* readingDateFormatter = [[NSDateFormatter alloc] init];
    
    // TODO: fix me to get correct GMT offset.
    [readingDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"];
    
    for (NSDictionary* seriesData in timeSeries) {
        // Get the USGS parameter ID.
        NSString* variableCodeValue = [[[[seriesData objectForKey:@"variable"] objectForKey:@"variableCode"] objectAtIndex:0] objectForKey:@"value"];
                                        
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
        
        // Get the DFGWaterReadingGroupType value for this timeSeries.
        DFGWaterReadingGroupType readingGroupType;
        
        if ([variableCodeValue isEqualToString:@"00065"]) {
            readingGroupType = DFGWaterReadingGroupTypeHeight;
        } else if ([variableCodeValue isEqualToString:@"00060"]) {
            readingGroupType = DFGWaterReadingGroupTypeDischarge;
        } else if ([variableCodeValue isEqualToString:@"00045"]) {
            readingGroupType = DFGWaterReadingGroupTypePrecipitation;
        }
        
        for (NSDictionary* value in [[[seriesData objectForKey:@"values"] objectAtIndex:0] objectForKey:@"value"]) {
            NSString* readingValue = [value objectForKey:@"value"];
            NSString* readingDateTime = [value objectForKey:@"dateTime"];
            NSMutableString* modifiedReadingDateTime = [NSMutableString stringWithString:readingDateTime];
            [modifiedReadingDateTime insertString:@"GMT" atIndex:23];
             
            NSDate* readingDate = [readingDateFormatter dateFromString:modifiedReadingDateTime];
            DFGWaterReading* reading = [[DFGWaterReading alloc] initWithValue:readingValue atDate:readingDate];
            
            [readingGroup addReading:reading ofType:readingGroupType forGauge:gauge];
        }
    }
    
    return readingGroup;
}

#pragma mark -
#pragma mark DFGError methods

- (NSString*)errorDomain
{
    return @"DFGWateUSGSIVJSONResponseParserErrors";
}

@end
