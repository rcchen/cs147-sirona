//
//  SironaAlertsViewController.h
//  Sirona
//
//  Created by Roger Chen on 11/14/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SironaAlertList.h"

@interface SironaAlertsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property UITableView *alertsTable;
@property SironaAlertList *alertList;

@end
