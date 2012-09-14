//
//  DFGWaterBaseURLStringProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 9/13/12.
//  Copyright (c) 2012 Half Off Depot. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DFGWaterBaseURLStringProtocol <NSObject>

@optional
- (id)initWithBaseURLString:(NSString*)theBaseURLString;

@property (nonatomic, strong) NSString* baseURLString;

@end
