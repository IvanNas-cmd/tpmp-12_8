#import "AppDelegate.h"
#import "Record+CoreDataClass.h"
@interface AppDelegate ()
@end
@implementation AppDelegate
@synthesize managedObjectContext, managedObjectModel, persistentStoreCoordinator;
- (BOOL)application:(UIApplication *)app didFinishLaunchingWithOptions:(NSDictionary *)opts {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        Record *f1 = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
        f1.cityFrom = @"Minsk"; f1.cityTo = @"Moscow"; f1.aviaCompany = @"Aeroflot"; f1.price = @1000;
        Record *f2 = [NSEntityDescription insertNewObjectForEntityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
        f2.cityFrom = @"Minsk"; f2.cityTo = @"Moscow"; f2.aviaCompany = @"Belavia"; f2.price = @800;
        [self saveContext];
    }
    return YES;
}
- (NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext) return managedObjectContext;
    NSPersistentStoreCoordinator *coord = [self persistentStoreCoordinator];
    if (coord) { managedObjectContext = [[NSManagedObjectContext alloc] init]; [managedObjectContext setPersistentStoreCoordinator:coord]; }
    return managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel) return managedObjectModel;
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
}
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator) return persistentStoreCoordinator;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"flight.sqlite"];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    return persistentStoreCoordinator;
}
- (void)saveContext {
    NSError *error = nil;
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) { NSLog(@"Error: %@", error); }
}
@end