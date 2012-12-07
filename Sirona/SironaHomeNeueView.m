//
//  SironaHomeNeueView.m
//  Sirona
//
//  Created by Roger Chen on 11/27/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaHomeNeueView.h"

#import "SironaTimeEditAlertView.h"
#import "SironaTimeAddNewMedicine.h"
#import "SironaHomeOnboardingController.h"

#import "stdlib.h"

@implementation SironaHomeNeueView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Home"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"53-house.png"];
        [tbi setImage:i];
        
        // Set the navigation item title as well
        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"Home", @"Application title")];
        
        // Boolean key for seeing the tutorial
        
        /*if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenTutorial"]) {
            
            // do something
            NSLog(@"Haven't seen the tutorial yet");
            
            // Handles the overlay
            UIViewController* c = [[UIViewController alloc] initWithNibName:@"SironaHomeOnboardingView" bundle:nil];
            UIView *overlayNone = [c view];
            //overlayNone.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
            [self.view addSubview:overlayNone];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];
            
        }*/
        
        //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasSeenTutorial"];


    }
    
    return self;
    
}

static NSDate *theDate;

// Returns the alert ID with the next fire date, or nil if there are none
- (NSString*)getNextAlert {
    
    // Creates mutable array of sorted fire dates
    NSMutableArray* sortedTimes = [[NSMutableArray alloc] init];
    for (UILocalNotification* localNotif in [[UIApplication sharedApplication] scheduledLocalNotifications])
        [sortedTimes addObject:[localNotif fireDate]];
    [sortedTimes sortUsingSelector:@selector(compare:)];
    
    NSDate* now = [[NSDate alloc] init];  // current date
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* nowComponentsDay = [calendar components:NSDayCalendarUnit fromDate:now];
    int currentDay = [nowComponentsDay day]; //gives you day
    
    // Remove the month/day/year information from NSDate, so that only time is compared
    unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* nowComponents = [calendar components:flags fromDate:now];
    NSDate* nowTimeOnly = [calendar dateFromComponents:nowComponents];
    
    NSMutableArray *beginningDates = [[NSMutableArray alloc] init];
    
    for (NSDate* date in sortedTimes) {
        // Find the day of date
        NSDateComponents* dateComponentsDay = [calendar components:NSDayCalendarUnit fromDate:date];
        int dateDay = [dateComponentsDay day];
        if (dateDay < currentDay) {
            [beginningDates addObject:date];
            continue;
        }
        
        // Get only the time of date
        NSDateComponents *dateComponents = [calendar components:flags fromDate:date];
        NSDate* dateTimeOnly = [calendar dateFromComponents:dateComponents];
        
        if ([nowTimeOnly compare:dateTimeOnly] == NSOrderedAscending) {
            // Closest alert time found! Now need to find corresponding local notif
            for (UILocalNotification* localNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
                if ([[localNotif fireDate] compare:date] == NSOrderedSame) {
                    theDate = [localNotif fireDate];
                    return [localNotif.userInfo objectForKey:@"alertID"];
                }
            }
        } else {
            [beginningDates addObject:date];
        }
    }
    
    if ([beginningDates count]) {
        // Closest alert time is simply the last of beginningDates. Now need to find corresponding local notif
        for (UILocalNotification* localNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            if ([[localNotif fireDate] compare:[beginningDates objectAtIndex:[beginningDates count] - 1]] == NSOrderedSame) {
                theDate = [localNotif fireDate];
                return [localNotif.userInfo objectForKey:@"alertID"];
            }
        }
    }
    
    return nil;
    
}

- (IBAction)onTimePress:(id)sender {
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^(void) {
                         CGPoint initPoint = timeCircle.frame.origin;
                         CGSize initSize = timeCircle.frame.size;
                         timeCircle.frame = CGRectMake(80, 100, 163, 163);
                         timeCircle.frame = CGRectMake(initPoint.x, initPoint.y, initSize.width, initSize.height);
                    }completion:NULL];
    
}

- (IBAction)onNextPress:(id)sender {
    
    NSLog(@"Pressed the next medication");
    
}

- (IBAction)onAddAlert:(id)sender {
    
    NSLog(@"Pressed the add alert button");
    
    SironaTimeEditAlertView *stevc = [[SironaTimeEditAlertView alloc] init];
    SironaAlertItem *newItem = [[SironaAlertItem alloc] init];
    [newItem setAlertId];
    [stevc setItem:newItem];
    [[self navigationController] pushViewController:stevc animated:YES];
    
}

- (IBAction)onAddMed:(id)sender {
    
    NSLog(@"Pressed the add medication button");
    
    // Push the add new medicine view controller
    SironaTimeAddNewMedicine *stanm = [[SironaTimeAddNewMedicine alloc] init];
    [[self navigationController] pushViewController:stanm animated:YES];
    
}

- (void)displayFirstMessage
{
    
    SironaHomeOnboardingController *shoc = [[SironaHomeOnboardingController alloc] init];
    [[self navigationController] presentModalViewController:shoc animated:YES];
    
}

- (void)viewDidLoad {
    
    [self getNextAlert];

    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    if (encodedAlertList) {
        NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        if ([prefAlerts count] == 0) {
            [medTitle setText:@"Welcome to Sirona"];
            [medDescription setText:@"Add an alert to begin"];
            [timeNumber setText:@"0"];
            [timeUnits setText:@"minutes"];
            [medDosage setText:@"0 pills"];
            [medRepetitions setText:@"0 times"];
        } else {
            
            SironaAlertItem *first = [prefAlerts objectAtIndex:0];
            [medTitle setText:[[first getLibraryItem] getName]];
            [medDescription setText:[[first getLibraryItem] getInstructions]];
            [medDosage setText:[[first getLibraryItem] getDosage]];
            [medRepetitions setText:[NSString stringWithFormat:@"%d", [[first getAlertTimes] count]]];
        
        }
    }

    /*
    [medTitle setText:@"Vitamins"];
    [medDescription setText:@"Remember to take after each meal"];
    [timeNumber setText:@"23"];
    [timeUnits setText:@"minutes"];
    [medDosage setText:@"2 pills"];
    [medRepetitions setText:@"3 times"];
    */

    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    bool firstTime = [prefs integerForKey:@"firstLaunch"];
    
    if (!firstTime) {
        [self displayFirstMessage];
        [prefs setBool:YES forKey:@"firstLaunch"];
    } else {
        
        NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
        if (encodedAlertList) {
            NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
            if ([prefAlerts count] == 0) {
                [medTitle setText:@"Welcome to Sirona"];
                [medDescription setText:@"Add an alert to begin"];
                [timeNumber setText:@"0"];
                [timeUnits setText:@"minutes"];
                [medDosage setText:@"0 pills"];
                [medRepetitions setText:@"0 times"];
            }
        }
        
        // Finish implementing this. Currently the result is not being used.
        NSString *alertId = [self getNextAlert];
        SironaAlertItem *alert = nil;
        
        NSArray *alerts;
        if (encodedAlertList)
            alerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        for (SironaAlertItem *a in alerts) {
            if ([[a getAlertId] isEqualToString:alertId]) {
                alert = a;
                break;
            }
        }
        
        if (!alert) {
            NSLog(@"Alert was not found. This shouldn't happen");
        } else {
            NSLog(@"Alert found. Name of med: %@", [[alert getLibraryItem] getName]);
            SironaLibraryItem *item = [alert getLibraryItem];
            [medTitle setText:[item getName]];
            [medDosage setText:[item getDosage]];
            NSString *times = [NSString stringWithFormat:@"%d times", [[alert getAlertTimes] count]];
            [medRepetitions setText:times];
            [medDescription setText:[item getNotes]];
            
            NSTimeInterval timeInterval = [theDate timeIntervalSinceNow];
            while (timeInterval < 0) {
                timeInterval += 604800;
            }
            
            if (timeInterval > 86400) {
                int answer = floor(timeInterval / 86400);
                [timeNumber setText:[NSString stringWithFormat:@"%d", answer]];
                [timeUnits setText:@"days"];
            } else if (timeInterval > 3600) {
                int answer = floor(timeInterval / 3600);
                [timeNumber setText:[NSString stringWithFormat:@"%d", answer]];
                [timeUnits setText:@"hours"];
            } else if (timeInterval > 60) {
                int answer = floor(timeInterval / 60);
                [timeNumber setText:[NSString stringWithFormat:@"%d", answer]];
                [timeUnits setText:@"minutes"];
            }
            
            //NSLog(@"Time since %@: %f", theDate, timeInterval);
            
            //[timeNumber setText:@"0"];
            //[timeUnits setText:@"minutes"];
        }
    }
    
}

- (void)viewDidUnload {
    
    timeCircle = nil;
    medTitle = nil;
    medDescription = nil;
    timeNumber = nil;
    timeUnits = nil;
    medDosage = nil;
    medRepetitions = nil;
    [super viewDidUnload];
    
}

@end
