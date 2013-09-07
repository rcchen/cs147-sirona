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

    }
    
    return self;
    
}

// Returns the alert ID with the next fire date, or nil if there are none
- (BOOL)getNextAlert:(NSString **)alertId withNotif:(UILocalNotification **)notif {
    
    UILocalNotification *earliest = nil;
    for (UILocalNotification* localNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if (earliest == nil || [[localNotif fireDate] compare:[earliest fireDate]] == NSOrderedAscending) {
            earliest = localNotif;
        }
    }
    
    if (earliest == nil) return FALSE;
    
    *alertId = [earliest.userInfo valueForKey:@"alertID"];
    *notif = earliest;
    return TRUE;
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
    
    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    if (encodedAlertList) {
        NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        if ([prefAlerts count] == 0) {
            [medTitle setText:@"Welcome to Sirona"];
            [medDescription setText:@"Add an alert to begin"];
            [timeNumber setText:@"?"];
            [timeUnits setText:@"minutes"];
            [medDosage setText:@"0 pills"];
            [medRepetitions setText:@"0 times"];
        } else {
            NSString *nextAlertId;
            UILocalNotification *notif;
            if (![self getNextAlert:&nextAlertId withNotif:&notif]) {
                NSLog(@"Failed to get next alert");
                return;
            }
            SironaAlertItem *first = nil;
            for (SironaAlertItem* item in prefAlerts) {
                if ([[item getAlertId] isEqualToString:nextAlertId])
                   first = item;
            }
            
            [medTitle setText:[[first getLibraryItem] getName]];
            [medDescription setText:[[first getLibraryItem] getInstructions]];
            NSString *dosage = [[first getLibraryItem] getDosage];
            if ([dosage length] == 0) dosage = @"?";
            [medDosage setText:[[first getLibraryItem] getDosage]];
            [medRepetitions setText:[NSString stringWithFormat:@"%d", [[first getAlertTimes] count]]];
        
        }
    }

    
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
        NSMutableArray *prefAlerts = nil;
        if (encodedAlertList) {
            prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
            if ([prefAlerts count] == 0) {
                [medTitle setText:@"Welcome to Sirona"];
                [medDescription setText:@"Add an alert to begin"];
                [timeNumber setText:@"?"];
                [timeUnits setText:@"minutes"];
                [medDosage setText:@"0 pills"];
                [medRepetitions setText:@"0 times"];
                return;
            }
        }
        
        NSString *nextAlertId;
        UILocalNotification *notif;
        if (![self getNextAlert:&nextAlertId withNotif:&notif]) {
            NSLog(@"Failed to get next alert");
            return;
        }
        SironaAlertItem *alert = nil;
        for (SironaAlertItem* item in prefAlerts) {
            if ([[item getAlertId] isEqualToString:nextAlertId])
                alert = item;
        }
        
        if (!alert) {
            NSLog(@"Alert was not found. This shouldn't happen");
        } else {
            NSLog(@"Alert found. Name of med: %@", [[alert getLibraryItem] getName]);
            SironaLibraryItem *item = [alert getLibraryItem];
            [medTitle setText:[item getName]];
            [medDosage setText:[item getDosage]];
            int alertTimesCount = [[alert getAlertTimes] count];
            NSString *timeEnd = (alertTimesCount == 1) ? @"time" : @"times";
            NSString *times = [NSString stringWithFormat:@"%d %@", alertTimesCount, timeEnd];
            [medRepetitions setText:times];
            [medDescription setText:[item getNotes]];
            
            NSTimeInterval timeInterval = [[notif fireDate] timeIntervalSinceNow];
            if (timeInterval < 0) {
                timeInterval = 0;
            }
            
            int answer = timeInterval / 60.0 + 0.5;
            NSString *interval = (answer == 1) ? @"minute" : @"minutes";
            if (answer >= 60) {
                answer = timeInterval / 3600.0 + 0.5;
                interval = (answer == 1) ? @"hour" : @"hours";
                if (answer >= 24) {
                    answer = timeInterval / 86400.0 + 0.5;
                    interval = (answer == 1) ? @"day" : @"days";
                }
            }
            [timeNumber setText:[NSString stringWithFormat:@"%d", answer]];
            [timeUnits setText:interval];
            
            //NSLog(@"Time since %@: %f", theDate, timeInterval);
            
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
