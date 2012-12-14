//
//  DFGWaterFavoritesManager.m
//  DFGWater
//
//  Created by Brian DeShong on 12/11/12.
//  Copyright (c) 2012 D5G Technology, LLC. All rights reserved.
//

#import "DFGWaterFavoritesManager.h"
#import "DFGWaterGauge.h"

@implementation DFGWaterFavoritesManager

@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;
@synthesize managedObjectContext;

- (id)initWithBundle:(NSBundle*)bundle
{
    self = [super init];
    
    if (self) {
        // Managed object model
        //managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:bundle]];
        managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:bundle]];
        
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
    return NO;
}

- (BOOL)isInFavorites:(DFGWaterGauge*)gauge
{
    NSLog(@"is in favorites?");

    // Determine if gage is in favorites
    NSEntityDescription *favoriteGaugeEntity = [NSEntityDescription entityForName:@"FavoriteGauge" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:favoriteGaugeEntity];
    
    NSPredicate *gaugeExistsByGaugeID = [NSPredicate predicateWithFormat:@"gaugeID = %@" argumentArray:[NSArray arrayWithObject:[gauge gaugeID]]];
    [request setPredicate:gaugeExistsByGaugeID];
    
    NSError *error;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    
    NSLog(@"matches count = %d", [matches count]);
    
    return ([matches count] > 0);
}

- (BOOL)removeFromFavorites:(DFGWaterGauge*)gauge
{
    NSLog(@"remove from favorites");
    return YES;
}

@end