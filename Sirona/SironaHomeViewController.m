//
//  SironaHomeViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/7/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaHomeViewController.h"
#import "SironaAlertItem.h"
#import "SironaHomeView.h"

@implementation SironaHomeViewController

- (void)updateTime:(NSTimer *)timer {
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm:ss a"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    [timeLabel setText:dateString];
    
}

- (void)circleAppear
{
    
    [timeLabel setHidden:YES];
    
    // instantaneously make the image view small (scaled to 1% of its actual size)
    circleOne.transform = CGAffineTransformMakeScale(0.01, 0.01);
    circleTwo.transform = CGAffineTransformMakeScale(0.01, 0.01);
    circleThree.transform = CGAffineTransformMakeScale(0.01, 0.01);
    circleFour.transform = CGAffineTransformMakeScale(0.01, 0.01);
    circleFive.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [circleOne setHidden:NO];
    [circleTwo setHidden:NO];
    [circleThree setHidden:NO];
    [circleFour setHidden:NO];
    [circleFive setHidden:NO];
    
    // Animate in circle one
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        circleOne.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    // Animate in circle two
    [UIView animateWithDuration:0.4 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        circleTwo.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    // Animate in circle three
    [UIView animateWithDuration:0.4 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        circleThree.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    // Animate in circle four
    [UIView animateWithDuration:0.4 delay:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        circleFour.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    // Animate in circle five
    [UIView animateWithDuration:0.4 delay:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        circleFive.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
    
    [timeLabel setHidden:NO];
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats: YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self findTopFive];
    [self circleAppear];
}

- (void)viewDidLoad
{
    [self circleAppear];
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

- (void)cleanupObjects
{
    // instantaneously make the image view small (scaled to 1% of its actual size)
    [circleOne setHidden:YES];
    [circleTwo setHidden:YES];
    [circleThree setHidden:YES];
    [circleFour setHidden:YES];
    [circleFive setHidden:YES];
    [timeLabel setHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self cleanupObjects];
}

- (void)viewDidUnload
{
    [self cleanupObjects];
}

- (NSMutableArray *)findTopFive
{
    
    NSMutableArray *topFive = [[NSMutableArray alloc] init];
    NSMutableArray *userAlerts = [[NSMutableArray alloc] init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    if (encodedAlertList) {
        userAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
    }
    
    for (SironaAlertItem *alert in userAlerts)
    {
        
        NSDate *today = [NSDate date];
        
        NSLog(@"Today is %@", today);
        
        for (NSString *day in [alert getAlertDays]) {
            for (NSString *time in [alert getAlertTimes]) {
                NSLog(@"Day: %@\tTime: %@", day, time);
            }
        }
    }
    
    return topFive;
    
}

@end
