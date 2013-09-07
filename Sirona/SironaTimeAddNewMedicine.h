//
//  SironaTimeAddNewMedicine.h
//  Sirona
//
//  Created by Catherine Lu on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SironaAlertItem.h"
#import "SironaAlertList.h"

@interface SironaTimeAddNewMedicine : UITableViewController <UITextFieldDelegate, UITextViewDelegate>
{
    
}

//@property NSMutableArray *medicines;
@property NSArray *medicineSections;
@property NSMutableArray *textFields;
@property NSArray *placeholderText;
@property NSMutableArray *inputtedText;
@property (nonatomic, strong)SironaAlertItem *item;
@property SironaAlertList *alertList;

// Default setter
- (void)setMedicines:(NSMutableArray *)medicines;

@end
