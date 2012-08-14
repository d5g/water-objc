//
//  DFGGaugesByLocationRequestBuilder.h
//  FloodWatch
//
//  Created by Brian DeShong on 8/9/12.
//  Copyright (c) 2012 Brian DeShong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeFinderRequestBuilderProtocol.h"

@interface DFGWaterGaugeFinderAPIRequestBuilder : NSObject <DFGWaterGaugeFinderRequestBuilderProtocol>

- (id)initWithBaseURLString:(NSString*)theBaseURLString;

@property (nonatomic, strong) NSString* baseURLString;

@end
