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

@synthesize gauges;
@synthesize sinceDate;
@synthesize endDate;
@synthesize numDaysAgo;
@synthesize height;
@synthesize precipitation;
@synthesize discharge;
@synthesize delegate;

// Get readings in date range for specific parameters.
- (id)initWithGauges:(NSArray*)theGauges
          numDaysAgo:(NSUInteger)theNumDaysAgo
           sinceDate:(NSDate*)theSinceDate
             endDate:(NSDate*)theEndDate
              height:(BOOL)theHeight
       precipitation:(BOOL)thePrecipitation
           discharge:(BOOL)theDischarge
            delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate;
{
    self = [super init];
    
    if (self) {
        gauges = theGauges;
        numDaysAgo = theNumDaysAgo;
        sinceDate = theSinceDate;
        endDate = theEndDate;
        height = theHeight;
        precipitation = thePrecipitation;
        discharge = theDischarge;
        delegate = theDelegate;
    }
    
    return self;
}

// Get the most recent reading for all parameters.
- (id)initWithGaugeForAllMostRecentReadings:(DFGWaterGauge*)theGauge
                                   delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate;
{
    return [self initWithGauges:[NSArray arrayWithObject:theGauge]
                     numDaysAgo:0
                      sinceDate:nil
                        endDate:nil
                         height:YES
                  precipitation:YES
                      discharge:YES
                       delegate:theDelegate];
}

- (id)initWithGaugesForAllMostRecentReadings:(NSArray*)theGauges
                                    delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate
{
    return [self initWithGauges:theGauges
                     numDaysAgo:0
                      sinceDate:nil
                        endDate:nil
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
    return [self initWithGauges:[NSArray arrayWithObject:theGauge]
                     numDaysAgo:0
                      sinceDate:nil
                        endDate:nil
                         height:theHeight
                  precipitation:thePrecipitation
                      discharge:theDischarge
                       delegate:theDelegate];
}

// Get reading from n number of days ago for specific parameters.
- (id)initWithGauge:(DFGWaterGauge*)theGauge
         numDaysAgo:(NSUInteger)theNumDaysAgo
             height:(BOOL)theHeight
      precipitation:(BOOL)thePrecipitation
          discharge:(BOOL)theDischarge
           delegate:(id<DFGWaterGaugeDataRetrieverDelegateProtocol>)theDelegate
{
    return [self initWithGauges:[NSArray arrayWithObject:theGauge]
                     numDaysAgo:theNumDaysAgo
                      sinceDate:nil
                        endDate:nil
                         height:theHeight
                  precipitation:thePrecipitation
                      discharge:theDischarge
                       delegate:theDelegate];
}

@end
