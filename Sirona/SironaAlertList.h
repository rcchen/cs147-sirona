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

+ (SironaAlertList *)sharedAlerts;

- (NSArray *)allAlerts;
- (void)createAlert:(SironaAlertItem *)alert;

@end
