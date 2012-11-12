//
//  SironaTimeEditTimesView.h
//  Sirona
//
//  Created by Roger Chen on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SironaAlertItem.h"

@interface SironaTimeEditTimesView : UITableViewController
{
    
}

@property SironaAlertItem *item;

- (void)setItem:(SironaAlertItem *)item;
- (IBAction)addTime:(id)sender;

@end
