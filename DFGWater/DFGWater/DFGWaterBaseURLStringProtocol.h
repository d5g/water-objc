//
//  DFGWaterBaseURLStringProtocol.h
//  DFGWater
//
//  Created by Brian DeShong on 9/13/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DFGWaterBaseURLStringProtocol <NSObject>

@optional
- (id)initWithBaseURLString:(NSString*)theBaseURLString;

- (id)initWithBaseURLString:(NSString*)theBaseURLString
                    version:(NSString*)theVersion;

@property (nonatomic, strong) NSString* baseURLString;
@property (nonatomic, strong) NSString* version;

@end
