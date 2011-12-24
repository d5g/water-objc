//
//  DFGWaterRetrievalParameters.h
//  DFGWater
//
//  Created by Brian DeShong on 12/23/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFGWaterRetrievalParameters : NSObject

// Static method to create an autoreleased parameters object.
+ (DFGWaterRetrievalParameters*)paramsWithHeight:(BOOL)theHeight
                                   precipitation:(BOOL)thePrecipitation
                                       discharge:(BOOL)theDischarge;

// Designated initializer.
- (id)initWithHeight:(BOOL)theHeight
       precipitation:(BOOL)thePrecipitation
           discharge:(BOOL)theDischarge;

// Retrieve gauge height?
@property (nonatomic, readonly) BOOL height;

// Retrieve precipitation?
@property (nonatomic, readonly) BOOL precipitation;

// Retrieve discharge?
@property (nonatomic, readonly) BOOL discharge;

@end
