//
//  DFGWaterFavoritesManager.m
//  DFGWater
//
//  Created by Brian DeShong on 12/11/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterFavoritesManager.h"
#import "DFGWaterGauge.h"
#import "DFGWaterReading.h"

@interface DFGWaterFavoritesManager ()

- (NSManagedObject*)favoriteGaugeByGaugeID:(DFGWaterGauge*)gauge;

@end

@implementation DFGWaterFavoritesManager

@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;

- (id)initWithBundle:(NSBundle*)bundle
{
    self = [super init];

    if (self) {
        NSLog(@"trying");
        // Managed object model
        //managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

        NSString* bundlePath = [[NSBundle mainBundle] pathForResource:@"DFGWaterModels"
                                                     ofType:@"bundle"];
        NSBundle* modelsBundle = [NSBundle bundleWithPath:bundlePath];
        NSString* modelPath = [modelsBundle pathForResource:@"FloodWatch2"
                                     ofType:@"momd"];
        NSURL* modelURL = [NSURL fileURLWithPath:modelPath];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        // Persistent store setup
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        
        NSDictionary *pscOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                    [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                    nil];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
        
        NSError* error;
        NSURL *dbFileURL = [NSURL fileURLWithPath:[basePath stringByAppendingPathComponent:@"floodwatch2.db"]];

        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbFileURL options:pscOptions error:&error]) {
            NSLog(@"unresolved error %@, %@", error, [error userInfo]);
        }

        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    
    return self;
}

- (BOOL)addToFavorites:(DFGWaterGauge*)gauge
{
    NSLog(@"add to favorites");
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"FavoriteGauge" inManagedObjectContext:managedObjectContext];
    NSManagedObject* favorite = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    
    [favorite setValue:[gauge gaugeID] forKey:@"gaugeID"];
    [favorite setValue:[gauge agency] forKey:@"agency"];
    [favorite setValue:[gauge agencySlug] forKey:@"agencySlug"];
    [favorite setValue:[gauge name] forKey:@"name"];
    [favorite setValue:[NSDecimalNumber numberWithFloat:[gauge locationCoordinate].latitude] forKey:@"locationLatitude"];
    [favorite setValue:[NSDecimalNumber numberWithFloat:[gauge locationCoordinate].longitude] forKey:@"locationLongitude"];
    [favorite setValue:[[gauge lastHeightReading] value] forKey:@"lastHeightReadingValue"];
    [favorite setValue:[[gauge lastHeightReading] date] forKey:@"lastHeightReadingDate"];
    [favorite setValue:[[gauge lastHeightReading] unit] forKey:@"lastHeightReadingUnit"];
    
    [managedObjectContext insertObject:favorite];
    
    NSError* error;
    [managedObjectContext save:&error];
    
    return NO;
}

- (BOOL)isInFavorites:(DFGWaterGauge*)gauge
{
    BOOL isInFavorites = [self favoriteGaugeByGaugeID:gauge] != nil;
    NSLog(@"is in favorites? %d", isInFavorites);
    return isInFavorites;
}

- (BOOL)removeFromFavorites:(DFGWaterGauge*)gauge
{
    NSLog(@"remove from favorites");
    
    NSManagedObject* favoriteGauge = [self favoriteGaugeByGaugeID:gauge];
    
    if (!favoriteGauge) {
        return NO;
    }
    
    [managedObjectContext deleteObject:favoriteGauge];
    
    NSError* error;
    [managedObjectContext save:&error];
    
    return YES;
}

- (NSArray*)allFavorites:(DFGWaterFavoritesSortType)sort error:(NSError*)error
{
    NSEntityDescription *favoriteGaugeEntity = [NSEntityDescription entityForName:@"FavoriteGauge" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:favoriteGaugeEntity];

    // No predicate -- get them all.
    [request setPredicate:[NSPredicate predicateWithValue:YES]];
    
    NSArray* favorites = [managedObjectContext executeFetchRequest:request error:&error];
    
    // TODO: turn me into DFGWaterGauge objects.
    
    return favorites;
}

- (NSManagedObject*)favoriteGaugeByGaugeID:(DFGWaterGauge*)gauge
{
    // Determine if gage is in favorites
    NSEntityDescription *favoriteGaugeEntity = [NSEntityDescription entityForName:@"FavoriteGauge" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:favoriteGaugeEntity];
    
    NSPredicate *gaugeExistsByGaugeID = [NSPredicate predicateWithFormat:@"gaugeID = %@" argumentArray:[NSArray arrayWithObject:[gauge gaugeID]]];
    [request setPredicate:gaugeExistsByGaugeID];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    
    if ([matches count] == 0) {
        return nil;
    }
    
    return [matches objectAtIndex:0];
}

@end