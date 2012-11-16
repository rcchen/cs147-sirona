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

- (IBAction)addTime:(id)sender
{
    
    // Add the time to the array as a string in 24 hr format
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"h:mm a"];
    NSString *dateString = [timeFormat stringFromDate:[datePicker date]];
    [alertTimes addObject:dateString];
    
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
