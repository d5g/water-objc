//
//  DFGWaterServiceRequestBuilderProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFGWaterGaugeDataRequestParameters;

@protocol DFGWaterServiceRequestBuilderProtocol <NSObject>

- (NSURLRequest*)buildRequest:(DFGWaterGaugeDataRequestParameters*)theParameters
                        error:(NSError**)error;

@end
