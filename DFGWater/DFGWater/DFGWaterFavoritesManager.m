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
- (DFGWaterGauge*)gaugeFromManagedObject:(NSManagedObject*)mo;

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
    [favorite setValue:[gauge agencyGaugeID] forKey:@"agencyGaugeID"];
    [favorite setValue:[gauge agencySlug] forKey:@"agencySlug"];
    [favorite setValue:[gauge name] forKey:@"name"];
    [favorite setValue:[NSDecimalNumber numberWithFloat:[gauge locationCoordinate].latitude] forKey:@"locationLatitude"];
    [favorite setValue:[NSDecimalNumber numberWithFloat:[gauge locationCoordinate].longitude] forKey:@"locationLongitude"];
    [favorite setValue:[[gauge lastHeightReading] value] forKey:@"lastHeightReadingValue"];
    [favorite setValue:[[gauge lastHeightReading] date] forKey:@"lastHeightReadingDate"];
    [favorite setValue:[[gauge lastHeightReading] unit] forKey:@"lastHeightReadingUnit"];
    [favorite setValue:[NSNumber numberWithInt:[gauge heightStatus]] forKey:@"heightStatus"];
    
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
    
    NSArray* mos = [managedObjectContext executeFetchRequest:request error:&error];
    
    // TODO: turn me into DFGWaterGauge objects.

    NSMutableArray* favorites = [NSMutableArray arrayWithCapacity:2];
    
    for (NSManagedObject* mo in mos) {
        [favorites addObject:[self gaugeFromManagedObject:mo]];
    }
    
    return [NSArray arrayWithArray:favorites];
}

#pragma mark -
#pragma mark Private methods

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

- (DFGWaterGauge*)gaugeFromManagedObject:(NSManagedObject*)mo
{
    DFGWaterGauge* gauge = [[DFGWaterGauge alloc] init];
    
    // Basic data
    [gauge setGaugeID:[mo valueForKey:@"gaugeID"]];
    [gauge setAgency:[mo valueForKey:@"agency"]];
    [gauge setAgencySlug:[mo valueForKey:@"agencySlug"]];
    [gauge setAgencyGaugeID:[mo valueForKey:@"agencyGaugeID"]];
    [gauge setName:[mo valueForKey:@"name"]];
    
    // Location
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[mo valueForKey:@"locationLatitude"] floatValue], [[mo valueForKey:@"locationLongitude"] floatValue]);
    [gauge setLocationCoordinate:location];
    
    // Last height reading
    NSString* lastHeightValue = [mo valueForKey:@"lastHeightReadingValue"];
    NSString* lastHeightUnit = [mo valueForKey:@"lastHeightReadingUnit"];
    NSDate* lastHeightDate = [mo valueForKey:@"lastHeightReadingDate"];
    DFGWaterReading* lastHeightReading = [[DFGWaterReading alloc] initWithValue:lastHeightValue unit:lastHeightUnit atDate:lastHeightDate];
    [gauge setLastHeightReading:lastHeightReading];
    
    // Height status
    [gauge setHeightStatus:[[mo valueForKey:@"heightStatus"] intValue]];

    return gauge;
}

@end