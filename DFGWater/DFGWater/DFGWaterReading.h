//
//  DFGWaterReading.h
//  DFGWater
//
//  Created by Brian DeShong on 12/24/11.
//  Copyright (c) 2011 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFGWaterReading : NSObject

- (id)initWithValue:(NSString*)theValue unit:(NSString*)theUnit atDate:(NSDate*)theDate;

- (NSDecimalNumber*)valueAsDecimalNumber;
- (NSString*)valueWithUnit;
- (BOOL)hasDate;

@property (nonatomic, readonly, copy) NSString* value;
@property (nonatomic, readonly, strong) NSDate* date;
@property (nonatomic, readonly, copy) NSString* unit;

@end
