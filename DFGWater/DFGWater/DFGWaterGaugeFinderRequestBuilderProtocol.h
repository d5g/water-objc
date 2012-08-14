//
//  DFGGaugesByLocationRequestBuilder.h
//  FloodWatch
//
//  Created by Brian DeShong on 8/9/12.
//  Copyright (c) 2012 Brian DeShong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DFGWaterGaugeFinderRequestBuilderProtocol <NSObject>

- (NSURLRequest*)buildWithLatitude:(float)theLatitude
                         longitude:(float)theLongitude
                     radiusInMiles:(float)theRadius
                            agency:(NSString*)theAgency
                             limit:(NSUInteger)theLimit;


@end