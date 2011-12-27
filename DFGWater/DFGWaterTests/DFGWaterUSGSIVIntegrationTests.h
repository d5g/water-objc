//
//  DFGWaterUSGSIVIntegrationTests.h
//  DFGWater
//
//  Created by Brian DeShong on 12/26/11.
//  Copyright (c) 2011 Half Off Depot. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import "DFGWater.h"

@interface DFGWaterUSGSIVIntegrationTests : SenTestCase <DFGWaterGaugeDataRetrieverDelegateProtocol>

@end
