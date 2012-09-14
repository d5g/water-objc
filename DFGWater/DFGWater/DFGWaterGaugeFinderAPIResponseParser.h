//
//  DFGWaterGaugeFinderAPIResponseParser.h
//  DFGWater
//
//  Created by Brian DeShong on 5/28/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeFinderResponseParserProtocol.h"
#import "DFGError.h"

@interface DFGWaterGaugeFinderAPIResponseParser : NSObject <DFGWaterGaugeFinderResponseParserProtocol, DFGError>

@end
