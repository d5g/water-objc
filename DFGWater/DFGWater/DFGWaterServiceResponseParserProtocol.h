//
//  DFGWaterServiceResponseParserProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGError.h"

@class DFGWaterGaugeDataRequestParameters;
@class DFGWaterReadingGroup;

typedef enum {
    DFGWaterServiceResponseParserProtocolErrorNoDataToParse = 1,
    DFGWaterServiceResponseParserProtocolErrorUnableToParseData,
} DFGWaterServiceResponseParserError;

@protocol DFGWaterServiceResponseParserProtocol <NSObject, DFGError>

- (DFGWaterReadingGroup*)parseResponse:(NSURLResponse*)theResponse
                              withData:(NSData*)theData
                            parameters:(DFGWaterGaugeDataRequestParameters*)theParams
                                 error:(NSError**)theError;

@end
