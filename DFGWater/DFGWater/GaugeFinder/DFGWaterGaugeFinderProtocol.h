//
//  DFGWaterGaugeFinderProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 5/27/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeFinderContext.h"

typedef enum {
    DFGWaterGaugeFinderErrorInadequateParameters = 1,
    DFGWaterGaugeFinderErrorUnableToBuildRequest,
    DFGWaterGaugeFinderErrorUnableToParseResponse,
} DFGWaterGaugeFinderError;

@class DFGWaterGaugeFinderContext;

@protocol DFGWaterGaugeFinderProtocol <NSObject>

- (BOOL)findByContext:(DFGWaterGaugeFinderContext*)context
                error:(NSError**)error;

@end
