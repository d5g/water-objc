//
//  DFGWaterReadingGroup.h
//  DFGWater
//
//  Created by Brian DeShong on 12/28/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFGWaterGauge;
@class DFGWaterReading;

typedef enum {
    DFGWaterReadingGroupTypeHeight = 1,
    DFGWaterReadingGroupTypePrecipitation,
    DFGWaterReadingGroupTypeDischarge
} DFGWaterReadingGroupType;

@interface DFGWaterReadingGroup : NSObject

- (void)addReading:(DFGWaterReading*)reading
            ofType:(DFGWaterReadingGroupType)groupType
          forGauge:(DFGWaterGauge*)gauge;

- (NSArray*)gauge:(DFGWaterGauge*)gauge
   readingsOfType:(DFGWaterReadingGroupType)groupType;

@property (nonatomic, strong, readonly) NSMutableDictionary* readingsByGauge;

@end
