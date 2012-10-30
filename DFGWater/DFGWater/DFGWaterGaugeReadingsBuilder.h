//
//  DFGWaterGaugeReadingsBuilder.h
//  DFGWater
//
//  Created by Brian DeShong on 10/29/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFGWaterGaugeReadingsBuilder : NSObject

- (NSArray*)buildReadings:(NSDictionary*)rawReadingValues;

@end
