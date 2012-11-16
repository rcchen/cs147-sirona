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
#import "SironaAlertsViewController.h"
#import "SironaTimeEditAlertView.h"

@implementation SironaHomeViewController

@synthesize topFive;
@synthesize alerts;

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
    [labelOne setHidden:YES];
    [labelTwo setHidden:YES];
    [labelFour setHidden:YES];
    [labelFive setHidden:YES];
    
    labelOne.adjustsFontSizeToFitWidth = YES;
    labelOne.minimumFontSize = 0;
    
    labelTwo.adjustsFontSizeToFitWidth = YES;
    labelTwo.minimumFontSize = 0;
    
    labelFour.adjustsFontSizeToFitWidth = YES;
    labelFour.minimumFontSize = 0;
    
    labelFive.adjustsFontSizeToFitWidth = YES;
    labelFive.minimumFontSize = 0;
    
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
        [labelOne setHidden:NO];
        // if you want to do something once the animation finishes, put it here
    }];
    
    // Animate in circle two
    [UIView animateWithDuration:0.4 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        circleTwo.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [labelTwo setHidden:NO];
        // if you want to do something once the animation finishes, put it here
    }];
    
    // Animate in circle four
    [UIView animateWithDuration:0.4 delay:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        circleFour.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [labelFour setHidden:NO];
        // if you want to do something once the animation finishes, put it here
    }];
    
    // Animate in circle five
    [UIView animateWithDuration:0.4 delay:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        circleFive.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [labelFive setHidden:NO];
        // if you want to do something once the animation finishes, put it here
    }];
    
    // Animate in circle three
    [UIView animateWithDuration:0.4 delay:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        circleThree.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [timeLabel setHidden:NO];
        // if you want to do something once the animation finishes, put it here
    }];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats: YES];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    topFive = [self findTopFive];
    NSLog(@"Top five: %@", topFive);
    
    [self circleAppear];
    
    labelTwo.text = [[[topFive objectAtIndex:0] getLibraryItem] getBrand];
    labelFour.text = [[[topFive objectAtIndex:1] getLibraryItem] getBrand];
    labelOne.text = [[[topFive objectAtIndex:3] getLibraryItem] getBrand];
    labelFive.text = [[[topFive objectAtIndex:4] getLibraryItem] getBrand];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [self cleanupObjects];
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


- (IBAction)pressLabel:(id)sender
{
    
    NSArray *notifs = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification* notif in notifs)
        NSLog(@"%@", [notif fireDate]);
    
    NSLog(@"This works");
    
    SironaTimeEditAlertView *steav = [[SironaTimeEditAlertView alloc] init];
    
    [steav setItem:[topFive objectAtIndex:3]];
    
    //SironaAlertsViewController *savc = [[SironaAlertsViewController alloc] init];
    //[[self navigationController] pushViewController:timeViewController animated:YES];
    
    [[self navigationController] pushViewController:steav animated:YES];
    
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


- (void)viewDidUnload
{
    [self cleanupObjects];
}


- (NSMutableArray *)findTopFive
{
    
    NSMutableArray *bigFive = [[NSMutableArray alloc] init];
    NSMutableArray *userAlerts = [[NSMutableArray alloc] init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    if (encodedAlertList) {
        userAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
    }
    
    NSDate *today = [NSDate date];
    NSLog(@"Today is %@", today);
    
    for (SironaAlertItem *alert in userAlerts)
    {
        
        if ([bigFive count] == 5) {
            break;
        }
        
        [bigFive addObject:alert];

    }

    while ([bigFive count] < 5) {
        
        SironaAlertItem *item = [[SironaAlertItem alloc] init];
        SironaLibraryItem *libItem = [[SironaLibraryItem alloc] initWithMDataBrand:@":)" mdataCategory:@"" mdataId:@"" mdataName:@"" mdataPrecautions:@"" mdataSideEffects:@"" mdataNotes:@""];
        [item setLibraryItem:libItem];
        [bigFive addObject:item];
        
    }
    
    [bigFive sortUsingSelector:@selector(compare:)];
    
    return bigFive;
    
}





@end
