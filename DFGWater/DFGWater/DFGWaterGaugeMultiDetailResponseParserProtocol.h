//
//  DFGWaterGaugeMultiDetailResponseParserProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 5/1/13.
//  Copyright (c) 2013 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DFGWaterGaugeMultiDetailResponseParserProtocolErrorNoDataToParse = 1,
    DFGWaterGaugeMultiDetailResponseParserProtocolErrorUnableToParseData,
    DFGWaterGaugeMultiDetailResponseParserProtocolErrorServiceIndicatesFailure
} DFGWaterGaugeMultiDetailResponseParserError;

@protocol DFGWaterGaugeMultiDetailResponseParserProtocol <NSObject>

- (NSDictionary*)parseResponse:(NSURLResponse*)theResponse
                      withData:(NSData*)theData
                         error:(NSError**)theError;

@end
