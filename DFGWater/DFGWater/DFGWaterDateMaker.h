//
//  DFGWaterDateMaker.h
//  DFGWater
//
//  Created by Brian DeShong on 9/16/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFGWaterDateMaker : NSObject

- (NSDate*)dateFromISODateString:(NSString*)string;

@end
