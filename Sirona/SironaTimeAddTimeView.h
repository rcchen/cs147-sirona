//
//  SironaTimeAddTimeView.h
//  Sirona
//
//  Created by Roger Chen on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SironaAlertItem.h"
#import "SironaAlertList.h"

@interface SironaTimeAddTimeView : UIViewController
{
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UITextField *timeText;
}

// Some properties that we want to access
@property NSMutableArray *alertTimes;
@property SironaAlertItem *item;
@property SironaAlertList *alertList;

// Setters
- (void)setAlertTimes:(NSMutableArray *)alertTimes;
// Button responses
- (IBAction)addTime:(id)sender;

@end
