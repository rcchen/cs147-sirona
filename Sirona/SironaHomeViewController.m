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

- (void)viewDidLoad
{
    

    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    // instantaneously make the image view small (scaled to 1% of its actual size)
    orangeCircle.transform = CGAffineTransformMakeScale(0.01, 0.01);
    blueCircle.transform = CGAffineTransformMakeScale(0.01, 0.01);
    greenCircle.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        orangeCircle.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    [UIView animateWithDuration:0.4 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        blueCircle.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    [UIView animateWithDuration:0.4 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        greenCircle.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
}

- (IBAction)pressBoom:(id)sender
{
    
    // instantaneously make the image view small (scaled to 1% of its actual size)
    orangeCircle.transform = CGAffineTransformMakeScale(0.01, 0.01);
    blueCircle.transform = CGAffineTransformMakeScale(0.01, 0.01);
    greenCircle.transform = CGAffineTransformMakeScale(0.01, 0.01);

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        orangeCircle.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    [UIView animateWithDuration:0.4 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        blueCircle.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    [UIView animateWithDuration:0.4 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        greenCircle.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
}

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
