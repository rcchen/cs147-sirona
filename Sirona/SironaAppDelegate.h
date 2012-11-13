//
//  SironaAppDelegate.h
//  Sirona
//
//  Created by Roger Chen on 11/7/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SironaAlertList.h"

@interface SironaAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property SironaAlertList *userAlerts;

@end
