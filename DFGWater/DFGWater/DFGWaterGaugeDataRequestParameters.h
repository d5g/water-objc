//
//  DFGWaterRetrievalParameters.h
//  DFGWater
//
//  Created by Brian DeShong on 12/23/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFGWaterGaugeDataRequestParameters : NSObject

// Get the most recent reading for all parameters.
- (id)initWithGaugeIDForAllMostRecentReadings:(NSString*)theGaugeID;

// Get the most recent reading for specific parameters.
- (id)initWithGaugeIDForMostRecentReading:(NSString*)theGaugeID
                                   height:(BOOL)theHeight
                            precipitation:(BOOL)thePrecipitation
                                discharge:(BOOL)theDischarge;

// Get readings in date range for specific parameters.
- (id)initWithGaugeID:(NSString*)theGaugeID
            sinceDate:(NSDate*)theSinceDate
              endDate:(NSDate*)theEndDate
               height:(BOOL)theHeight
        precipitation:(BOOL)thePrecipitation
            discharge:(BOOL)theDischarge;

// Get reading from n number of days ago for specific parameters.
- (id)initWithGaugeID:(NSString*)theGaugeID
           numDaysAgo:(NSUInteger)theNumDaysAgo
               height:(BOOL)theHeight
        precipitation:(BOOL)thePrecipitation
            discharge:(BOOL)theDischarge;

// ID of gauge; agency-agnostic
@property (readonly, strong) NSString* gaugeID;

//
// Date-based criteria
//

@property (readonly, strong) NSDate* sinceDate;
@property (readonly, strong) NSDate* endDate;
@property (readonly) NSUInteger numDaysAgo;

// Retrieve gauge height?
@property (readonly) BOOL height;

// Retrieve precipitation?
@property (readonly) BOOL precipitation;

// Retrieve discharge?
@property (readonly) BOOL discharge;

// Delegate to receive any callbacks
@property (readonly, weak) id delegate;

@end
