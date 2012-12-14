//
//  DFGWaterFavoritesManager.h
//  DFGWater
//
//  Created by Brian DeShong on 12/11/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DFGWaterGauge;

@interface DFGWaterFavoritesManager : NSObject

- (id)initWithBundle:(NSBundle*)bundle;
- (BOOL)addToFavorites:(DFGWaterGauge*)gauge;
- (BOOL)isInFavorites:(DFGWaterGauge*)gauge;
- (BOOL)removeFromFavorites:(DFGWaterGauge*)gauge;

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end
