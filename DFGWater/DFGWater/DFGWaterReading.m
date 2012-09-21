//
//  DFGWaterReading.m
//  DFGWater
//
//  Created by Brian DeShong on 12/24/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterReading.h"

@implementation DFGWaterReading

@synthesize value;
@synthesize unit;
@synthesize date;

- (id)initWithValue:(NSString*)theValue unit:(NSString*)theUnit atDate:(NSDate*)theDate
{
    self = [super init];
    
    if (self) {
        value = [theValue copy];
        unit = [theUnit copy];
        date = theDate;
    }
    
    return self;
}

- (NSString*)valueWithUnit
{
    return [NSString stringWithFormat:@"%@ %@", [self value], [self unit]];
}

- (NSDecimalNumber*)valueAsDecimalNumber
{
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSDecimalNumber* decimal = (NSDecimalNumber*)[formatter numberFromString:value];
    
    return decimal;
}

- (BOOL)hasDate
{
    return date != nil;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"value = %@; when = %@", value, date];
}

@end
