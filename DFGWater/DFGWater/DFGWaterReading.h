//
//  DFGWaterReading.h
//  DFGWater
//
//  Created by Brian DeShong on 12/24/11.
//  Copyright (c) 2011 Half Off Depot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFGWaterReading : NSObject

- (id)initWithValue:(NSString*)theValue;
- (id)initWithValue:(NSString*)theValue atDate:(NSDate*)theDate;

- (BOOL)hasDate;

@property (nonatomic, readonly, copy) NSString* value;
@property (nonatomic, readonly, strong) NSDate* date;

@end
