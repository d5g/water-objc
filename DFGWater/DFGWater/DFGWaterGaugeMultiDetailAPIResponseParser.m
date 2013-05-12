//
//  DFGWaterGaugeMultiDetailAPIResponseParser.m
//  DFGWater
//
//  Created by Brian DeShong on 5/1/13.
//  Copyright (c) 2013 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeMultiDetailAPIResponseParser.h"

@implementation DFGWaterGaugeMultiDetailAPIResponseParser

- (NSDictionary*)parseResponse:(NSURLResponse*)theResponse
                      withData:(NSData*)theData
                         error:(NSError**)theError;
{
    if ([theData length] == 0) {
        if (theError != NULL) {
            *theError = [NSError errorWithDomain:[self errorDomain]
                                            code:DFGWaterGaugeMultiDetailResponseParserProtocolErrorNoDataToParse
                                        userInfo:nil];
        }
        
        return nil;
    }
    
    NSError* jsonParseError;
    NSDictionary* dict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:theData options:0 error:&jsonParseError];
    
    if (!dict) {
        if (theError != NULL) {
            *theError = [NSError errorWithDomain:[self errorDomain]
                                            code:DFGWaterGaugeMultiDetailResponseParserProtocolErrorUnableToParseData
                                        userInfo:nil];
        }
        
        return nil;
    }
    
    if ([[dict objectForKey:@"success"] boolValue] != YES) {
        if (theError != NULL) {
            *theError = [NSError errorWithDomain:[self errorDomain]
                                            code:DFGWaterGaugeMultiDetailResponseParserProtocolErrorServiceIndicatesFailure
                                        userInfo:nil];
        }
        
        return nil;
    }
    
    return dict;
}

- (NSString*)errorDomain
{
    return @"DFGWaterGaugeMultiDetailAPIResponseParserErrors";
}

@end
