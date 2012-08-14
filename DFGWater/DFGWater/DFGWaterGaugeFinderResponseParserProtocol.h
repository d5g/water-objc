//
//  DFGWaterGaugeFinderResponseParserProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 5/27/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DFGWaterGaugeFinderResponseParserProtocolErrorNoDataToParse = 1,
    DFGWaterGaugeFinderResponseParserProtocolErrorUnableToParseData,
    DFGWaterGaugeFinderResponseParserProtocolErrorServiceIndicatesFailure
} DFGWaterGaugeFinderResponseParserError;

@class DFGWaterGaugeFinderContext;

@protocol DFGWaterGaugeFinderResponseParserProtocol <NSObject>

- (NSArray*)parseResponse:(NSURLResponse*)theResponse
                 withData:(NSData*)theData
                    error:(NSError**)theError;

@end
