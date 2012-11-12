//
//  SironaTimeEditViewController.h
//  Sirona
//
//  Created by Roger Chen on 11/9/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SironaAlertItem.h"

@interface SironaTimeEditViewController : UITableViewController
{
    __weak IBOutlet UIButton *setAlert;
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UITableView *alertSettings;
    __weak IBOutlet UISegmentedControl *dayPicker;
}

@property (nonatomic, strong)SironaAlertItem *item;

@property NSMutableArray *alarmSettings;

- (void)setItem:(SironaAlertItem *)theItem;
- (void)saveItem:(SironaAlertItem *)theItem;

@end
