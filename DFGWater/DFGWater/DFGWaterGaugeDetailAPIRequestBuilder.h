//
//  DFGWaterGaugeDetailAPIRequestBuilder.h
//  DFGWater
//
//  Created by Brian DeShong on 9/13/12.
//  Copyright (c) 2012 Half Off Depot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeDetailRequestBuilderProtocol.h"
#import "DFGWaterBaseURLStringProtocol.h"

@interface DFGWaterGaugeDetailAPIRequestBuilder : NSObject <DFGWaterGaugeDetailRequestBuilderProtocol, DFGWaterBaseURLStringProtocol>

- (id)initWithBaseURLString:(NSString*)theBaseURLString
                    version:(NSString*)theVersion;

@property (nonatomic, strong) NSString* version;

@end
