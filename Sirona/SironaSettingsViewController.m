//
//  SironaSettingsViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaSettingsViewController.h"

@implementation SironaSettingsViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    
    // Call the superclass' designated initializer
    self = [super initWithNibName:nil bundle:nil];
    
    // If it exists, then we can customize it
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Settings"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"19-gear.png"];
        [tbi setImage:i];
        
    }
    
    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification* notif in notifs)
        NSLog(@"%@", [notif fireDate]);
    
    return self;
    
}

@end
