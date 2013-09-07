//
//  SironaAlertList.h
//  Sirona
//
//  Created by Roger Chen on 11/9/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SironaAlertItem;

@interface SironaAlertList : NSObject
{
    NSMutableArray *allAlerts;
}

- (NSArray *)allAlerts;
- (void)addAlert:(SironaAlertItem *)alert;
- (void)deleteAlert:(SironaAlertItem *)alert;
- (void)removeUnsaved;
- (int)count;
- (SironaAlertItem *)objectAtIndex:(NSUInteger)index;
- (void)removeObjectAtIndex:(NSUInteger)index;

@end
