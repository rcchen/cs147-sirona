//
//  SironaTimeEditDaysView.h
//  Sirona
//
//  Created by Roger Chen on 11/11/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SironaAlertItem.h"
#import "SironaAlertList.h"

@interface SironaTimeEditDaysView : UITableViewController

@property NSMutableArray *possibleDays;
@property SironaAlertItem *item;
@property SironaAlertList *alertList;

// - (IBAction)finishEditingDays:(id)sender;
- (void)setItem:(SironaAlertItem *)item;

@end
