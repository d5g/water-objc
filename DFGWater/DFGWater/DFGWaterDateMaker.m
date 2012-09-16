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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    return [dateFormatter dateFromString:string];
}

@end
