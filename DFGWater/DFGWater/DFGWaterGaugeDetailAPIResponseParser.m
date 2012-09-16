//
//  DFGWaterGaugeDetailAPIResponseParser.m
//  DFGWater
//
//  Created by Brian DeShong on 9/15/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeDetailAPIResponseParser.h"

@implementation DFGWaterGaugeDetailAPIResponseParser

- (NSDictionary*)parseResponse:(NSURLResponse*)theResponse
                      withData:(NSData*)theData
                         error:(NSError**)theError
{
    if ([theData length] == 0) {
        if (theError != NULL) {
            *theError = [NSError errorWithDomain:[self errorDomain]
                                            code:DFGWaterGaugeDetailResponseParserProtocolErrorNoDataToParse
                                        userInfo:nil];
        }
        
        return nil;
    }
    
    NSError* jsonParseError;
    NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonParseError];
    
    if (!dict) {
        if (theError != NULL) {
            *theError = [NSError errorWithDomain:[self errorDomain]
                                            code:DFGWaterGaugeDetailResponseParserProtocolErrorUnableToParseData
                                        userInfo:nil];
        }
        
        return nil;
    }
    
    if ([[dict objectForKey:@"success"] boolValue] != YES) {
        if (theError != NULL) {
            *theError = [NSError errorWithDomain:[self errorDomain]
                                            code:DFGWaterGaugeDetailResponseParserProtocolErrorServiceIndicatesFailure
                                        userInfo:nil];
        }
        
        return nil;
    }
    
    return dict;
}

- (NSString*)errorDomain
{
    return @"DFGWaterGaugeDetailAPIResponseParserErrors";
}

@end
