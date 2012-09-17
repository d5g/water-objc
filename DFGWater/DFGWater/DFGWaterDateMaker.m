//
//  DFGWaterDateMaker.m
//  DFGWater
//
//  Created by Brian DeShong on 9/16/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterDateMaker.h"

@implementation DFGWaterDateMaker

- (NSDate*)dateFromISODateString:(NSString*)string
{
    // 2012-09-16T03:17:23+00:00
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    return [dateFormatter dateFromString:string];
}

@end
