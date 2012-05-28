//
//  DFGWaterReadingGroup.m
//  DFGWater
//
//  Created by Brian DeShong on 12/28/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterReadingGroup.h"
#import "DFGWaterGauge.h"

@interface DFGWaterReadingGroup ()

- (NSString*)groupTypeStringWithType:(DFGWaterReadingGroupType)groupType;

@end

@implementation DFGWaterReadingGroup

@synthesize readingsByGauge;

- (void)addReading:(DFGWaterReading*)reading
            ofType:(DFGWaterReadingGroupType)groupType
          forGauge:(DFGWaterGauge*)gauge
{
    if (!readingsByGauge) {
        readingsByGauge = [[NSMutableDictionary alloc] initWithCapacity:1];
    }

    // Key the dictionary by gauge ID, then a string of group type.
    NSString* gaugeID = [gauge gaugeID];
    NSString* groupTypeKey = [self groupTypeStringWithType:groupType];
    
    NSMutableDictionary* readingsForThisGauge = [readingsByGauge objectForKey:gaugeID];
    
    if (!readingsForThisGauge) {
        readingsForThisGauge = [[NSMutableDictionary alloc] initWithCapacity:1];
        [readingsByGauge setObject:readingsForThisGauge forKey:gaugeID];
    }
    
    NSMutableArray* readingsForType = [[readingsByGauge objectForKey:gaugeID] objectForKey:groupTypeKey];
    
    if (!readingsForType) {
        readingsForType = [[NSMutableArray alloc] initWithCapacity:1];
        [readingsForThisGauge setObject:readingsForType forKey:groupTypeKey];
    }
    
    [readingsForType addObject:reading];
}

- (NSArray*)gauge:(DFGWaterGauge*)gauge
   readingsOfType:(DFGWaterReadingGroupType)groupType
{
    NSString* gaugeID = [gauge gaugeID];
    NSString* groupTypeKey = [self groupTypeStringWithType:groupType];
    
    if (![readingsByGauge objectForKey:gaugeID]) {
        return nil;
    }
    
    if (![[readingsByGauge objectForKey:gaugeID] objectForKey:groupTypeKey]) {
        return nil;
    }
    
    return [NSArray arrayWithArray:[[readingsByGauge objectForKey:gaugeID] objectForKey:groupTypeKey]];
}

- (NSString*)groupTypeStringWithType:(DFGWaterReadingGroupType)groupType
{
    NSString* groupTypeKey;
    
    switch (groupType) {
        case DFGWaterReadingGroupTypeHeight:
            groupTypeKey = @"height";
            break;
        case DFGWaterReadingGroupTypePrecipitation:
            groupTypeKey = @"precipitation";
            break;
        case DFGWaterReadingGroupTypeDischarge:
            groupTypeKey = @"discharge";
            break;
        default:
            [NSException raise:@"DFGWaterReadingGroupExceptionUnknownType" format:@"unexpected reading group type; type = %i", groupType];
    }

    return groupTypeKey;
}

- (NSString*)description
{
    return [readingsByGauge description];
}

@end
