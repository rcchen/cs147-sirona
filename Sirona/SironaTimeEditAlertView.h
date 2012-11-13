//
//  SironaTimeEditAlertView.h
//  Sirona
//
//  Created by Roger Chen on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SironaAlertItem.h"
#import "SironaAlertList.h"

@interface SironaTimeEditAlertView : UITableViewController

@property (nonatomic, strong)SironaAlertItem *item;
@property NSMutableArray *alertList;
@property NSMutableArray *alertSettings;

- (void)setAlertList:(NSMutableArray *)alertList;
- (IBAction)saveAlert:(id)sender;

@end