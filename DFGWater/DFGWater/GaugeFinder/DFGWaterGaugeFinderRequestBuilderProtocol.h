//
//  DFGWaterGaugeFinderRequestBuilderProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 5/27/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeFinderContext.h"

@protocol DFGWaterGaugeFinderRequestBuilderProtocol <NSObject>

- (NSURLRequest*)buildRequest:(DFGWaterGaugeFinderContext*)theContext
                        error:(NSError**)error;

@end
