//
//  SironaTimeAddNewMedicine.h
//  Sirona
//
//  Created by Catherine Lu on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SironaAlertItem.h"

@interface SironaTimeAddNewMedicine : UITableViewController <UITextFieldDelegate>
{
    
}

//@property NSMutableArray *medicines;
@property NSMutableArray *medicineSections;
@property NSMutableArray *textFields;
@property (nonatomic, strong)SironaAlertItem *item;

// Default setter
- (void)setMedicines:(NSMutableArray *)medicines;

@end
