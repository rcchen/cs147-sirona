//
//  SironaAlertList.m
//  Sirona
//
//  Created by Roger Chen on 11/9/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaAlertList.h"
#import "SironaAlertItem.h"

@implementation SironaAlertList

- (id)init
{
    self = [super init];
    if (self) {        
        // Get previous allAlerts if possible
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
        if (encodedAlertList) {
            allAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        } else {
            allAlerts = [[NSMutableArray alloc] init];
            encodedAlertList = [NSKeyedArchiver archivedDataWithRootObject:allAlerts];
            [prefs setObject:encodedAlertList forKey:@"alertList"];
        }
    } return self;
}

- (NSArray *)allAlerts
{
    return allAlerts;
}

- (void)addAlert:(SironaAlertItem *)alert
{
    // Remove possible duplicate
    for (SironaAlertItem *sai in allAlerts) {
        if ([[sai getAlertId] isEqualToString:[alert getAlertId]]) {
            [allAlerts removeObject:sai];
            break;
        }
    }
    
    [allAlerts addObject:alert];
    
    // Resave prefs
    [self savePrefs];

    NSLog(@"SironaAlertList.m: %@", alert);
}

- (void)deleteAlert:(SironaAlertItem *)alert
{
    [allAlerts removeObject:alert];
    
    // Resave prefs
    [self savePrefs];
}

- (int)count
{
    return [allAlerts count];
}

- (void)removeUnsaved
{
    /*NSMutableArray *discardedItems = [NSMutableArray array];
    for (SironaAlertItem *sai in allAlerts) {
        if (![sai isSaved]) {
            [discardedItems addObject:sai];
        }
    }
    [allAlerts removeObjectsInArray:discardedItems];
    
    [self savePrefs];*/
}

- (void)savePrefs
{
    NSData *encodedAlertList = [NSKeyedArchiver archivedDataWithRootObject:allAlerts];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:encodedAlertList forKey:@"alertList"];
}

- (SironaAlertItem *)objectAtIndex:(NSUInteger)index {
    return [allAlerts objectAtIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [allAlerts removeObjectAtIndex:index];
}

@end
