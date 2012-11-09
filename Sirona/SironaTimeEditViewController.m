//
//  SironaTimeEditViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/9/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeEditViewController.h"
#import "SironaAlertItem.h"

@implementation SironaTimeEditViewController

@synthesize item;

- (void)setItem:(SironaAlertItem *)theItem
{
    item = theItem;
    [[self navigationItem] setTitle:[[item getLibraryItem] getBrand]];
}

- (void)viewDidUnload {
    dayPicker = nil;
    alertSettings = nil;
    datePicker = nil;
    setAlert = nil;
    [super viewDidUnload];
}

- (IBAction)scheduleAlarm:(id)sender
{
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    // Grab the picker time, floor func to reset seconds to 0
    NSDate *pickerDate = [datePicker date];
    NSTimeInterval time = floor([pickerDate timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    pickerDate = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    
    // Set the local notification
    localNotif.fireDate = pickerDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    NSLog(@"Scheduled for %@", pickerDate);
    
    // It's an alert of some sort that we want to schedule
    localNotif.alertBody = @"Time to take your Vicodin!";
    localNotif.alertAction = @"View";
    localNotif.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
}

@end
