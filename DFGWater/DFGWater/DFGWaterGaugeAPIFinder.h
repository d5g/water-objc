//
//  DFGGaugesByLocationRetriever.h
//  FloodWatch
//
//  Created by Brian DeShong on 8/9/12.
//  Copyright (c) 2012 Brian DeShong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeFinderProtocol.h"
#import "DFGWaterGaugeFinderRequestBuilderProtocol.h"

@interface DFGWaterGaugeAPIFinder : NSObject <DFGWaterGaugeFinderProtocol>

- (id)initWithRequestBuilder:(id<DFGWaterGaugeFinderRequestBuilderProtocol>)theRequestBuilder;

@property (nonatomic, strong) id<DFGWaterGaugeFinderRequestBuilderProtocol> requestBuilder;

@end