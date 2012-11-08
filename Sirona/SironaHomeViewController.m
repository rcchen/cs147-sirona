//
//  SironaHomeViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/7/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaHomeViewController.h"
#import "SironaHomeView.h"

@implementation SironaHomeViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    
    // Call the superclass' designated initializer
    self = [super initWithNibName:nil bundle:nil];
    
    // If it exists, then we can customize it
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Home"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"53-house.png"];
        [tbi setImage:i];
        
    }
    

    return self;
    
}

- (IBAction)pressButton:(id)sender
{
    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification* notif in notifs)
        NSLog(@"%@", [notif fireDate]);
}

@end
