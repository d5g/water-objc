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
- (void)handleGaugeUpdates:(DFGWaterGauge*)gauge;
- (void)unhandleGaugeUpdates:(DFGWaterGauge*)gauge;
- (DFGWaterReading*)readingObjectFromManagedObject:(NSManagedObject*)mo
                                          valueKey:(NSString*)valueKey
                                           unitKey:(NSString*)unitKey
                                           dateKey:(NSString*)dateKey;

@property (nonatomic, strong) NSMutableDictionary* favoritesByGaugeID;

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
        
        // Initialize our mapping of gauge ID to DFGWaterGauge objects.
        self.favoritesByGaugeID = [[NSMutableDictionary alloc] initWithCapacity:2];
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
    
    // Height values.
    [favorite setValue:[[gauge lastHeightReading] value] forKey:@"lastHeightReadingValue"];
    [favorite setValue:[[gauge lastHeightReading] date] forKey:@"lastHeightReadingDate"];
    [favorite setValue:[[gauge lastHeightReading] unit] forKey:@"lastHeightReadingUnit"];
    [favorite setValue:[NSNumber numberWithInt:[gauge heightStatus]] forKey:@"heightStatus"];
    
    // Precipitation values -- 24 hours.
    [favorite setValue:[[gauge precipitationPast24HoursReading] value] forKey:@"precipitation24HoursReadingValue"];
    [favorite setValue:[[gauge precipitationPast24HoursReading] date] forKey:@"precipitation24HoursReadingDate"];
    [favorite setValue:[[gauge precipitationPast24HoursReading] unit] forKey:@"precipitation24HoursReadingUnit"];
    
    // Precipitation values -- 7 days.
    [favorite setValue:[[gauge precipitationPast7DaysReading] value] forKey:@"precipitation7DaysReadingValue"];
    [favorite setValue:[[gauge precipitationPast7DaysReading] date] forKey:@"precipitation7DaysReadingDate"];
    [favorite setValue:[[gauge precipitationPast7DaysReading] unit] forKey:@"precipitation7DaysReadingUnit"];

    // Discharge values.
    [favorite setValue:[[gauge lastDischargeReading] value] forKey:@"lastDischargeReadingValue"];
    [favorite setValue:[[gauge lastDischargeReading] date] forKey:@"lastDischargeReadingDate"];
    [favorite setValue:[[gauge lastDischargeReading] unit] forKey:@"lastDischargeReadingUnit"];

    // Water temperature values.
    [favorite setValue:[[gauge lastWaterTemperatureReading] value] forKey:@"lastWaterTemperatureReadingValue"];
    [favorite setValue:[[gauge lastWaterTemperatureReading] date] forKey:@"lastWaterTemperatureReadingDate"];
    [favorite setValue:[[gauge lastWaterTemperatureReading] unit] forKey:@"lastWaterTemperatureReadingUnit"];
    
    [managedObjectContext insertObject:favorite];
    
    NSError* error;
    [managedObjectContext save:&error];
    
    // Add the gauge object to the cache of favorites.
    [[self favoritesByGaugeID] setObject:gauge forKey:[gauge gaugeID]];
    
    // Now that it's a favorite, listen for updates on the gauge.
    [self handleGaugeUpdates:gauge];
    
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
    
    [self unhandleGaugeUpdates:gauge];
    
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
    
    NSMutableArray* favorites = [NSMutableArray arrayWithCapacity:2];
    
    DFGWaterGauge* cachedFavorite = nil;
    
    for (NSManagedObject* mo in mos) {
        if ((cachedFavorite = [[self favoritesByGaugeID] objectForKey:[mo valueForKey:@"gaugeID"]])) {
            NSLog(@"returned id %@ from cache", [mo valueForKey:@"gaugeID"]);
            
            [favorites addObject:cachedFavorite];
        } else {
            //
            // NOTE: we will only do this on the first call for all favorites.
            // The objects are cached and reused on subsequent calls.
            //
            
            // Turn each managed object into a DFGWaterGauge.
            DFGWaterGauge* gauge = [self gaugeFromManagedObject:mo];
         
            // Cache the gauge object by its gauge ID value.
            [[self favoritesByGaugeID] setObject:gauge forKey:[gauge gaugeID]];

            NSLog(@"cached %@ in favorites cache", [mo valueForKey:@"gaugeID"]);

            [favorites addObject:gauge];
            
            // Now that we've returned it, listen for its updates.
            [self handleGaugeUpdates:gauge];
        }
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
    DFGWaterReading* lastHeightReading = [self readingObjectFromManagedObject:mo
                                                                     valueKey:@"lastHeightReadingValue"
                                                                      unitKey:@"lastHeightReadingUnit"
                                                                      dateKey:@"lastHeightReadingDate"];
    [gauge setLastHeightReading:lastHeightReading];
    
    // Height status
    [gauge setHeightStatus:[[mo valueForKey:@"heightStatus"] intValue]];
    
    // Precipitation reading -- 24 hours.
    DFGWaterReading* lastPrecip24HoursReading = [self readingObjectFromManagedObject:mo
                                                                            valueKey:@"precipitation24HoursReadingValue"
                                                                             unitKey:@"precipitation24HoursReadingUnit"
                                                                             dateKey:@"precipitation24HoursReadingDate"];
    [gauge setPrecipitationPast24HoursReading:lastPrecip24HoursReading];
    
    // Precipitation reading -- 7 days.
    DFGWaterReading* lastPrecip7DaysReading = [self readingObjectFromManagedObject:mo
                                                                          valueKey:@"precipitation7DaysReadingValue"
                                                                           unitKey:@"precipitation7DaysReadingUnit"
                                                                           dateKey:@"precipitation7DaysReadingDate"];
    [gauge setPrecipitationPast7DaysReading:lastPrecip7DaysReading];
    
    // Last discharge reading.
    DFGWaterReading* lastDischargeReading = [self readingObjectFromManagedObject:mo
                                                                        valueKey:@"lastDischargeReadingValue"
                                                                         unitKey:@"lastDischargeReadingUnit"
                                                                         dateKey:@"lastDischargeReadingDate"];
    
    [gauge setLastDischargeReading:lastDischargeReading];
    
    
    // Last water temperature reading.
    DFGWaterReading* lastWaterTemperatureReading = [self readingObjectFromManagedObject:mo
                                                                               valueKey:@"lastWaterTemperatureReadingValue"
                                                                                unitKey:@"lastWaterTemperatureReadingUnit"
                                                                                dateKey:@"lastWaterTemperatureReadingDate"];
    
    [gauge setLastWaterTemperatureReading:lastWaterTemperatureReading];

    return gauge;
}

- (void)handleGaugeUpdates:(DFGWaterGauge*)gauge
{
    NSLog(@"listening for updates on %@", [gauge gaugeID]);
}

- (void)unhandleGaugeUpdates:(DFGWaterGauge*)gauge
{
    NSLog(@"don't care about updates on %@", [gauge gaugeID]);    
}

- (DFGWaterReading*)readingObjectFromManagedObject:(NSManagedObject*)mo
                                          valueKey:(NSString*)valueKey
                                           unitKey:(NSString*)unitKey
                                           dateKey:(NSString*)dateKey
{
    NSString* lastValue = [mo valueForKey:valueKey];
    NSString* lastUnit = [mo valueForKey:unitKey];
    NSDate* lastDate = [mo valueForKey:dateKey];
    
    return [[DFGWaterReading alloc] initWithValue:lastValue unit:lastUnit atDate:lastDate];
}

@end