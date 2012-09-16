//
//  DFGWaterGaugeDetailResponseParserProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 9/15/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DFGWaterGaugeDetailResponseParserProtocolErrorNoDataToParse = 1,
    DFGWaterGaugeDetailResponseParserProtocolErrorUnableToParseData,
    DFGWaterGaugeDetailResponseParserProtocolErrorServiceIndicatesFailure
} DFGWaterGaugeDetailResponseParserError;

@protocol DFGWaterGaugeDetailResponseParserProtocol <NSObject>

- (NSDictionary*)parseResponse:(NSURLResponse*)theResponse
                      withData:(NSData*)theData
                         error:(NSError**)theError;

@end
