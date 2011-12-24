//
//  DFGWaterRetrievalParameters.h
//  DFGWater
//
//  Created by Brian DeShong on 12/23/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeDataRetrieverDelegateProtocol.h"

@interface DFGWaterGaugeDataRequestParameters : NSObject

// Get the most recent reading for all parameters.
- (id)initWithGaugeIDForAllMostRecentReadings:(NSString*)theGaugeID
                                     delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate;

// Get the most recent reading for specific parameters.
- (id)initWithGaugeIDForMostRecentReading:(NSString*)theGaugeID
                                   height:(BOOL)theHeight
                            precipitation:(BOOL)thePrecipitation
                                discharge:(BOOL)theDischarge
                                 delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate;

// Get readings in date range for specific parameters.
- (id)initWithGaugeID:(NSString*)theGaugeID
            sinceDate:(NSDate*)theSinceDate
              endDate:(NSDate*)theEndDate
               height:(BOOL)theHeight
        precipitation:(BOOL)thePrecipitation
            discharge:(BOOL)theDischarge
             delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate;

// Get reading from n number of days ago for specific parameters.
- (id)initWithGaugeID:(NSString*)theGaugeID
           numDaysAgo:(NSUInteger)theNumDaysAgo
               height:(BOOL)theHeight
        precipitation:(BOOL)thePrecipitation
            discharge:(BOOL)theDischarge
             delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate;

// ID of gauge; agency-agnostic
@property (nonatomic, readonly, strong) NSString* gaugeID;

//
// Date-based criteria
//

@property (nonatomic, readonly, strong) NSDate* sinceDate;
@property (nonatomic, readonly, strong) NSDate* endDate;
@property (nonatomic, readonly) NSUInteger numDaysAgo;

// Retrieve gauge height?
@property (nonatomic, readonly) BOOL height;

// Retrieve precipitation?
@property (nonatomic, readonly) BOOL precipitation;

// Retrieve discharge?
@property (nonatomic, readonly) BOOL discharge;

// Delegate to receive any callbacks
@property (nonatomic, readonly, weak) id<DFGWaterGaugeDataRetrieverDelegateProtocol> delegate;

@end
