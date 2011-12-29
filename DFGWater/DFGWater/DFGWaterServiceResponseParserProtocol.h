//
//  DFGWaterServiceResponseParserProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 Half Off Depot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFGWaterGaugeDataRequestParameters;
@class DFGWaterReadingGroup;

@protocol DFGWaterServiceResponseParserProtocol <NSObject>

- (DFGWaterReadingGroup*)parseResponse:(NSURLResponse*)theResponse
                              withData:(NSData*)theData
                            parameters:(DFGWaterGaugeDataRequestParameters*)theParams;

@end
