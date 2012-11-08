//
//  SironaTimeViewController.h
//  Sirona
//
//  Created by Roger Chen on 11/7/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SironaTimeViewController : UIViewController
{
    IBOutlet UILabel *timeLabel;
}

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

- (IBAction)showCurrentTime:(id)sender;
- (IBAction)scheduleAlarm:(id)sender;

@end
