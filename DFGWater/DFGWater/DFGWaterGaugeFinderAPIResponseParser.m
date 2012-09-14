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
                
        DFGWaterGauge* gauge = [[DFGWaterGauge alloc] init];
        [gauge setGaugeID:[interp extractGaugeID:gaugeDict]];
        [gauge setName:[interp extractName:gaugeDict]];
        [gauge setLocationCoordinate:[interp extractCoordinate:gaugeDict]];
        [gauge setAgency:[interp extractAgency:gaugeDict]];
        [gauge setAgencySlug:[interp extractAgencySlug:gaugeDict]];
        [gauge setStateCode:[interp extractStateCode:gaugeDict]];
        [gauge setCountyCode:[interp extractCountyCode:gaugeDict]];
        
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
