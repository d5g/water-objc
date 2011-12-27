//
//  DFGWaterUSGSIVJSONResponseParser.m
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 Half Off Depot. All rights reserved.
//

#import "DFGWaterUSGSIVJSONResponseParser.h"

@implementation DFGWaterUSGSIVJSONResponseParser

- (NSDictionary*)parseResponse:(NSURLResponse*)theResponse
                      withData:(NSData*)theData
                    parameters:(DFGWaterGaugeDataRequestParameters*)theParams
{
    return [NSDictionary dictionaryWithObject:@"TODO: complete me" forKey:@"foo"];
}

@end
