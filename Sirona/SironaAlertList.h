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

- (NSMutableArray *)allAlerts;
- (void)createAlert:(SironaAlertItem *)alert;
- (void)deleteAlert:(SironaAlertItem *)alert;

@end
