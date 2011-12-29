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
@synthesize date;

- (id)initWithValue:(NSString*)theValue atDate:(NSDate*)theDate
{
    self = [super init];
    
    if (self) {
        value = [theValue copy];
        date = theDate;
    }
    
    return self;
}

- (id)initWithValue:(NSString*)theValue
{
    return [self initWithValue:theValue atDate:nil];
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
