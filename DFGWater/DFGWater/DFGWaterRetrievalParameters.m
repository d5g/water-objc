//
//  DFGWaterRetrievalParameters.m
//  DFGWater
//
//  Created by Brian DeShong on 12/23/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterRetrievalParameters.h"

@implementation DFGWaterRetrievalParameters

@synthesize height;
@synthesize precipitation;
@synthesize discharge;

+ (DFGWaterRetrievalParameters*)paramsWithHeight:(BOOL)theHeight
                                   precipitation:(BOOL)thePrecipitation
                                       discharge:(BOOL)theDischarge
{
    return [[self alloc] initWithHeight:theHeight
                          precipitation:thePrecipitation
                              discharge:theDischarge];
}

- (id)initWithHeight:(BOOL)theHeight
       precipitation:(BOOL)thePrecipitation
           discharge:(BOOL)theDischarge
{
    self = [super init];
    
    if (self) {
        height = theHeight;
        precipitation = thePrecipitation;
        discharge = theDischarge;
    }
    
    return self;
}

@end
