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
@property NSMutableArray *alertList;

- (void)setItem:(SironaAlertItem *)item;
- (IBAction)addTime:(id)sender;
- (void)setAlertList:(NSMutableArray *)alertList;

@end
