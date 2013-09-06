//
//  SironaTimeAddTimeView.m
//  Sirona
//
//  Created by Roger Chen on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeAddTimeView.h"

@implementation SironaTimeAddTimeView

@synthesize alertTimes;
@synthesize alertList;
@synthesize item;

- (IBAction)addTime:(id)sender
{
    
    // Add the time to the array as an NSDate
    [alertTimes addObject:[datePicker date]];
    [item setAlertTimes:alertTimes];
    
    // Set the alerts from NSUserDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    if (encodedAlertList) {
        NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        alertList = prefAlerts;
    }
    
    // Remove the object if it exists already
    for (SironaAlertItem *sai in alertList) {
        NSLog(@"AlertID: %@, Item: %@", sai.getAlertId, item.getAlertId);
        if ([[sai getAlertId] isEqualToString:[item getAlertId]]) {
            NSLog(@"Removing duplicate object");
            [alertList removeObject:sai];
            break;
        }
    }
    
    //alertList = [[NSMutableArray alloc] init];
    
    // Add the item in
    [alertList addObject:item];
    
    NSLog(@"AlertID: %@", [item getAlertId]);
    
    // Now save it to NSUserDefaults
    encodedAlertList = [NSKeyedArchiver archivedDataWithRootObject:alertList];
    [prefs setObject:encodedAlertList forKey:@"alertList"];
    
    // Notification will be managed by hitting done in the prior menu
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad
{
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Bar button for "Done"
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self
                                action:@selector(addTime:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        
    }
    
    return self;
    
}


- (void)viewDidUnload {
    datePicker = nil;
    timeText = nil;
    [super viewDidUnload];
}
@end
