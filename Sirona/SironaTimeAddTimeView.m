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
    
    // Add the item in
    [alertList addAlert:item];
    
    NSLog(@"AlertID: %@", [item getAlertId]);
    
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
        
        alertList = [[SironaAlertList alloc] init];
    }
    
    return self;
    
}


- (void)viewDidUnload {
    datePicker = nil;
    timeText = nil;
    [super viewDidUnload];
}
@end
