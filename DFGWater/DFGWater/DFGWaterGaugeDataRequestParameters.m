//
//  DFGWaterRetrievalParameters.m
//  DFGWater
//
//  Created by Brian DeShong on 12/23/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeDataRequestParameters.h"

@implementation DFGWaterGaugeDataRequestParameters

@synthesize gaugeID;
@synthesize sinceDate;
@synthesize endDate;
@synthesize numDaysAgo;
@synthesize height;
@synthesize precipitation;
@synthesize discharge;
@synthesize delegate;

// Get the most recent reading for all parameters.
- (id)initWithGaugeIDForAllMostRecentReadings:(NSString*)theGaugeID
{
    return [self initWithGaugeIDForMostRecentReading:theGaugeID
                                              height:YES
                                       precipitation:YES
                                           discharge:YES];
}

// Get the most recent reading for specific parameters.
- (id)initWithGaugeIDForMostRecentReading:(NSString*)theGaugeID
                                   height:(BOOL)theHeight
                            precipitation:(BOOL)thePrecipitation
                                discharge:(BOOL)theDischarge
{
    self = [super init];
    
    if (self) {
        gaugeID = [theGaugeID copy];
        height = theHeight;
        precipitation = thePrecipitation;
        discharge = theDischarge;
    }
    
    return self;
}

// Get readings in date range for specific parameters.
- (id)initWithGaugeID:(NSString*)theGaugeID
            sinceDate:(NSDate*)theSinceDate
              endDate:(NSDate*)theEndDate
               height:(BOOL)theHeight
        precipitation:(BOOL)thePrecipitation
            discharge:(BOOL)theDischarge
{
    self = [super init];
    
    if (self) {
        gaugeID = [theGaugeID copy];
        sinceDate = theSinceDate;
        endDate = theEndDate;
        height = theHeight;
        precipitation = thePrecipitation;
        discharge = theDischarge;
    }
    
    return self;
}

// Get reading from n number of days ago for specific parameters.
- (id)initWithGaugeID:(NSString*)theGaugeID
           numDaysAgo:(NSUInteger)theNumDaysAgo
               height:(BOOL)theHeight
        precipitation:(BOOL)thePrecipitation
            discharge:(BOOL)theDischarge
{
    self = [super init];
    
    if (self) {
        gaugeID = [theGaugeID copy];
        numDaysAgo = theNumDaysAgo;
        height = theHeight;
        precipitation = thePrecipitation;
        discharge = theDischarge;
    }
    
    return self;
}

@end
