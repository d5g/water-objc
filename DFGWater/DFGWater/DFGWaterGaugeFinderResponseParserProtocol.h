//
//  DFGWaterGaugeFinderResponseParserProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 5/27/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFGWaterGaugeFinderContext;

@protocol DFGWaterGaugeFinderResponseParserProtocol <NSObject>

- (NSArray*)parseResponse:(NSURLResponse*)theResponse
                 withData:(NSData*)theData
                  context:(DFGWaterGaugeFinderContext*)theContext
                    error:(NSError**)theError;

@end
