//
//  DFGWaterUSGSGaugeDataRetriever.h
//  DFGWater
//
//  Created by Brian DeShong on 12/24/11.
//  Copyright (c) 2011 Half Off Depot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFGWaterGaugeDataRetrieverProtocol.h"
#import "DFGError.h"

@interface DFGWaterUSGSGaugeDataRetriever : NSObject <DFGWaterGaugeDataRetrieverProtocol, DFGError>

@end
