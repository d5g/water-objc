//
//  DFGWaterRetrievalParameters.m
//  DFGWater
//
//  Created by Brian DeShong on 12/23/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterGaugeDataRequestParameters.h"
#import "DFGWaterGauge.h"

@implementation DFGWaterGaugeDataRequestParameters

@synthesize gauge;
@synthesize sinceDate;
@synthesize endDate;
@synthesize numDaysAgo;
@synthesize height;
@synthesize precipitation;
@synthesize discharge;
@synthesize delegate;

// Get the most recent reading for all parameters.
- (id)initWithGaugeForAllMostRecentReadings:(DFGWaterGauge*)theGauge
                                   delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate
{
    return [self initWithGaugeForMostRecentReading:theGauge
                                            height:YES
                                     precipitation:YES
                                         discharge:YES
                                          delegate:theDelegate];
}

// Get the most recent reading for specific parameters.
- (id)initWithGaugeForMostRecentReading:(DFGWaterGauge*)theGauge
                                 height:(BOOL)theHeight
                          precipitation:(BOOL)thePrecipitation
                              discharge:(BOOL)theDischarge
                               delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate
{
    self = [super init];
    
    if (self) {
        gauge = theGauge;
        height = theHeight;
        precipitation = thePrecipitation;
        discharge = theDischarge;
        delegate = theDelegate;
    }
    
    return self;
}

// Get readings in date range for specific parameters.
- (id)initWithGauge:(DFGWaterGauge*)theGauge
          sinceDate:(NSDate*)theSinceDate
            endDate:(NSDate*)theEndDate
             height:(BOOL)theHeight
      precipitation:(BOOL)thePrecipitation
          discharge:(BOOL)theDischarge
           delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate
{
    self = [super init];
    
    if (self) {
        gauge = theGauge;
        sinceDate = theSinceDate;
        endDate = theEndDate;
        height = theHeight;
        precipitation = thePrecipitation;
        discharge = theDischarge;
        delegate = theDelegate;
    }
    
    return self;
}

// Get reading from n number of days ago for specific parameters.
- (id)initWithGauge:(DFGWaterGauge*)theGauge
         numDaysAgo:(NSUInteger)theNumDaysAgo
             height:(BOOL)theHeight
      precipitation:(BOOL)thePrecipitation
          discharge:(BOOL)theDischarge
           delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate
{
    self = [super init];
    
    if (self) {
        gauge = theGauge;
        numDaysAgo = theNumDaysAgo;
        height = theHeight;
        precipitation = thePrecipitation;
        discharge = theDischarge;
        delegate = theDelegate;
    }
    
    return self;
}

@end
