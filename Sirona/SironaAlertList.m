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

+ (SironaAlertList *)sharedAlerts
{
    static SironaAlertList *sharedAlerts = nil;
    if (!sharedAlerts)
        sharedAlerts = [[super allocWithZone:nil] init];
    return sharedAlerts;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedAlerts];
}

- (id)init
{
    self = [super init];
    if (self) {
        allAlerts = [[NSMutableArray alloc] init];
    } return self;
}

- (NSArray *)allAlerts
{
    return allAlerts;
}

- (void)createAlert:(SironaAlertItem *)alert
{
    [allAlerts addObject:alert];
    NSLog(@"SironaAlertList.m: %@", alert);
}

- (void)deleteAlert:(SironaAlertItem *)alert
{
    [allAlerts delete:alert];
}


@end
