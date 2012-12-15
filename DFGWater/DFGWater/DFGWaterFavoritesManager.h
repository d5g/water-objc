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

typedef enum {
    kDFGWaterFavoritesManagerSortNameAZ = 1,
    kDFGWaterFavoritesManagerSortNameZA = 1,
    kDFGWaterFavoritesManagerSortLastHeightValue,
    kDFGWaterFavoritesManagerSortLocationNorthToSouth,
    kDFGWaterFavoritesManagerSortLocationSouthToNorth,
    kDFGWaterFavoritesManagerSortLocationEastToWest,
    kDFGWaterFavoritesManagerSortLocationWestToEast,
    kDFGWaterFavoritesManagerSortHeightStatus
} DFGWaterFavoritesSortType;

@interface DFGWaterFavoritesManager : NSObject

- (id)initWithBundle:(NSBundle*)bundle;
- (BOOL)addToFavorites:(DFGWaterGauge*)gauge;
- (BOOL)isInFavorites:(DFGWaterGauge*)gauge;
- (BOOL)removeFromFavorites:(DFGWaterGauge*)gauge;
- (NSArray*)allFavorites:(DFGWaterFavoritesSortType)sort error:(NSError*)error;

@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

@end
