//
//  SironaAlertItem.h
//  Sirona
//
//  Created by Roger Chen on 11/9/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SironaLibraryItem.h"

@interface SironaAlertItem : NSObject
{
    SironaLibraryItem *sli;
    NSMutableArray *alertDays;
    NSMutableArray *alertTimes;
    NSString *alertID;
}

- (SironaLibraryItem *)getLibraryItem;
- (NSMutableArray *)getAlertDays;
- (NSMutableArray *)getAlertTimes;
- (NSString *)getAlertId;
- (void)setLibraryItem:(SironaLibraryItem *)item;
- (void)setAlertDays:(NSMutableArray*)days;
- (void)setAlertTimes:(NSMutableArray*)times;
- (void)setAlertId;

@end
