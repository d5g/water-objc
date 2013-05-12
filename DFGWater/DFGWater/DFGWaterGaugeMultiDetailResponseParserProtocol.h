//
//  DFGWaterGaugeMultiDetailResponseParserProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 5/1/13.
//  Copyright (c) 2013 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DFGWaterGaugeFinderResponseParserProtocolErrorNoDataToParse = 1,
    DFGWaterGaugeFinderResponseParserProtocolErrorUnableToParseData,
    DFGWaterGaugeFinderResponseParserProtocolErrorServiceIndicatesFailure
} DFGWaterGaugeFinderResponseParserError;

@protocol DFGWaterGaugeMultiDetailResponseParserProtocol <NSObject>

- (NSArray*)parseResponse:(NSURLResponse*)theResponse
                 withData:(NSData*)theData
                    error:(NSError**)theError;

@end
