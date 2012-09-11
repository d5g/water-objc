//
//  DFGWaterGaugeFinderAPIResponseParser.m
//  DFGWater
//
//  Created by Brian DeShong on 5/28/12.
//  Copyright (c) 2012 Half Off Depot. All rights reserved.
//

#import "DFGWaterGaugeFinderAPIResponseParser.h"
#import "DFGWaterGaugeFinderContext.h"
#import "DFGwaterGauge.h"

// TODO: DI me
#import "DFGWaterGaugeFinderAPIDataInterpreter.h"

@implementation DFGWaterGaugeFinderAPIResponseParser

- (NSArray*)parseResponse:(NSURLResponse*)theResponse
                 withData:(NSData*)theData
                    error:(NSError**)theError
{
    if ([theData length] == 0) {
        if (theError != NULL) {
            *theError = [NSError errorWithDomain:[self errorDomain]
                                            code:DFGWaterGaugeFinderResponseParserProtocolErrorNoDataToParse
                                        userInfo:nil];
        }
        
        return nil;
    }
    
    NSError* jsonParseError;
    NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonParseError];
    
    if (!dict) {
        if (theError != NULL) {
            *theError = [NSError errorWithDomain:[self errorDomain]
                                            code:DFGWaterGaugeFinderResponseParserProtocolErrorUnableToParseData
                                        userInfo:nil];
        }
        
        return nil;
    }
    
    if ([[dict objectForKey:@"success"] boolValue] != YES) {
        if (theError != NULL) {
            *theError = [NSError errorWithDomain:[self errorDomain]
                                            code:DFGWaterGaugeFinderResponseParserProtocolErrorServiceIndicatesFailure
                                        userInfo:nil];
        }
        
        return nil;        
    }
    
    NSMutableArray* theGauges = [NSMutableArray arrayWithCapacity:2];
    
    for (NSDictionary* gaugeDict in [dict objectForKey:@"gauges"]) {
        // TODO: DI me.
        DFGWaterGaugeFinderAPIDataInterpreter* interp = [[DFGWaterGaugeFinderAPIDataInterpreter alloc] init];
        
        DFGWaterGauge* gauge = [[DFGWaterGauge alloc] initWithGaugeID:[interp extractGaugeID:gaugeDict]
                                                                 name:[interp extractName:gaugeDict]
                                                   locationCoordinate:[interp extractCoordinate:gaugeDict]
                                                               agency:[interp extractAgency:gaugeDict]
                                                           agencySlug:[gaugeDict objectForKey:@"agency_slug"]
                                                            stateCode:[gaugeDict objectForKey:@"state_code"]
                                                           countyCode:[gaugeDict objectForKey:@"county_code"]
                                                   hydrologicUnitCode:nil]; // TODO: FIXME
        
        [theGauges addObject:gauge];
    }
    
    return [NSArray arrayWithArray:theGauges];
}

#pragma mark -
#pragma mark DFGError methods

- (NSString*)errorDomain
{
    return @"DFGWaterGaugeFinderAPIResponseParserErrors";
}

@end
