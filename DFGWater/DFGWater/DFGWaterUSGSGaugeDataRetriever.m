//
//  DFGWaterUSGSGaugeDataRetriever.m
//  DFGWater
//
//  Created by Brian DeShong on 12/24/11.
//  Copyright (c) 2011 Half Off Depot. All rights reserved.
//

#import "DFGWaterUSGSGaugeDataRetriever.h"

@implementation DFGWaterUSGSGaugeDataRetriever

- (BOOL)retrieveData:(DFGWaterGaugeDataRequestParameters*)params
               error:(NSError**)error
{
    if (params == nil) {
        if (error != NULL) {
            NSDictionary* userDict = [NSDictionary dictionaryWithObject:@"must pass non-nil parameters"
                                                                 forKey:NSLocalizedDescriptionKey];
            *error = [NSError errorWithDomain:[self errorDomain]
                                         code:DFGWaterGaugeDataRetrieverErrorInadequateParameters
                                     userInfo:userDict];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark DFGError methods

- (NSString*)errorDomain
{
    return @"DFGWaterUSGSGaugeDataRetrieverErrors";
}

@end
