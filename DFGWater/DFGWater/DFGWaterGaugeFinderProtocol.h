//
//  DFGGaugesByLocationRetrieverProtocol.h
//  FloodWatch
//
//  Created by Brian DeShong on 8/9/12.
//  Copyright (c) 2012 Brian DeShong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^DFGGaugesByLocationRetrieverSuccessBlock)(NSArray* theGauges);
typedef void (^DFGGaugesByLocationRetrieverErrorBlock)(NSURLResponse* response, NSData *data, NSString* errorMessage);

@protocol DFGWaterGaugeFinderProtocol <NSObject>

- (BOOL)retrieveWithLocation:(CLLocationCoordinate2D)theCoordinate
               radiusInMiles:(float)theRadius
                      agency:(NSString*)theAgency
                       limit:(NSUInteger)theLimit
                successBlock:(DFGGaugesByLocationRetrieverSuccessBlock)theSuccessBlock
                  errorBlock:(DFGGaugesByLocationRetrieverErrorBlock)theErrorBlock;


@end