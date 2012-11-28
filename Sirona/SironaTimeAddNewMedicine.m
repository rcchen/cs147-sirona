//
//  SironaTimeAddNewMedicine.m
//  Sirona
//
//  Created by Catherine Lu on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeAddNewMedicine.h"
#import "SironaTimeAddNewMedicineCell.h"
#import "SironaTimeAddNewMedicineNoteCell.h"
#import "SironaLibraryItem.h"
#import "SironaLibraryList.h"

@implementation SironaTimeAddNewMedicine

@synthesize medicineSections;
@synthesize textFields;
@synthesize item;
@synthesize alertList;

- (IBAction)saveMedicine:(id)sender
{
    
    NSString *name = [[textFields objectAtIndex:0] text];
    // Checks the name field, which cannot be blank. Shows an alert if it is.
    if ([name length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Medication name cannot be blank"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *category = [[textFields objectAtIndex:1] text];
    if ([category length] == 0)
        category = @"";
     
    NSString *notes = [[textFields objectAtIndex:2] text];
    if ([notes length] == 0)
        notes = @"";
    
    // Save the information
    SironaLibraryItem *sli = [[SironaLibraryItem alloc] initWithMDataBrand:name mdataCategory:category mdataId:@"" mdataName:@"" mdataPrecautions:@"" mdataSideEffects:@"" mdataNotes:notes];
    
    [item setLibraryItem:sli];
    
    // Now save it to NSUserDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedCustomMedList = [prefs objectForKey:@"customMedList"];
    
    NSMutableArray *customMeds;
    
    if (encodedCustomMedList) {
        customMeds = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedCustomMedList];
    } else {
        customMeds = [[NSMutableArray alloc] init];
    }
    [customMeds addObject:sli];
    
    encodedCustomMedList = [NSKeyedArchiver archivedDataWithRootObject:customMeds];
    [prefs setObject:encodedCustomMedList forKey:@"customMedList"];
    
    // Set the alerts from NSUserDefaults
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    if (encodedAlertList) {
        NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        alertList = prefAlerts;
    }
    
    // Remove the object if it exists already
    for (SironaAlertItem *sai in alertList) {
        NSLog(@"AlertID: %@, Item: %@", sai.getAlertId, item.getAlertId);
        if ([[sai getAlertId] isEqualToString:[item getAlertId]]) {
            NSLog(@"Removing duplicate object");
            [alertList removeObject:sai];
            break;
        }
    }
    
    // Add the item in
    [alertList addObject:item];
    
    NSLog(@"AlertID: %@", [item getAlertId]);
    
    // Now save it to NSUserDefaults
    encodedAlertList = [NSKeyedArchiver archivedDataWithRootObject:alertList];
    [prefs setObject:encodedAlertList forKey:@"alertList"];
    
    int count = [self.navigationController.viewControllers count];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:count-3] animated:YES];
}

/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [errorAlert dismissWithClickedButtonIndex:buttonIndex animated:YES];
    NSLog(@"HI");
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [medicineSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[medicineSections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL_ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if ([indexPath section] == 0) { // Medicine Info section
        UITextField *inputField;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            inputField = [[UITextField alloc] initWithFrame:CGRectMake(130, 12, 180, 30)];
            inputField.adjustsFontSizeToFitWidth = NO;
            [textFields addObject:inputField];
            // Unique tag for the UITextField
            //inputField.tag = [indexPath row];
            [cell addSubview:inputField];
            [inputField setDelegate:self];
            
        }
        inputField.keyboardType = UIKeyboardTypeDefault;
        switch ([indexPath row]) {
            case 0:
                cell.textLabel.text = @"Brand";
                break;
            case 1:
                cell.textLabel.text = @"Category";
                break;
            case 2:
                cell.textLabel.text = @"Precautions";
                break;
            case 3:
                cell.textLabel.text = @"Side effects";
                break;
            default:
                break;
        }
    } else { // Notes section
        UITextView *inputField;
        if (cell == nil ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            inputField = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, 280, 260)];
            inputField.backgroundColor = [UIColor clearColor];
            [textFields addObject:inputField];
            // Unique tag for the UITextField
            //inputField.tag = 2;
            [cell addSubview:inputField];
            [inputField setFont:[UIFont systemFontOfSize:18]];
            
        }
    }
        
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// Disallows table cells to be selected
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"Medication Info";
    } else { // section == 1
        return @"Notes";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1) {
        return 280.0f;
    } return 44.0f;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                target:self
                                action:@selector(saveMedicine:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        self.title = @"Add Medicine";
        
    }
    
    NSArray *sectionOne = [[NSArray alloc] initWithObjects:@"Brand", @"Category", @"Precautions", @"Side effects", nil];
    NSArray *sectionTwo = [[NSArray alloc] initWithObjects:@"", nil];
    
    medicineSections = [[NSMutableArray alloc] initWithObjects:sectionOne, sectionTwo, nil];
    
    textFields = [[NSMutableArray alloc] init];
    
    self.editing = NO;
    
    return self;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"SironaTimeAddNewMedicineCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"SironaTimeAddNewMedicineCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"SironaTimeAddNewMedicineNoteCell" bundle:nil];
    [[self tableView] registerNib:nib2 forCellReuseIdentifier:@"SironaTimeAddNewMedicineNoteCell"];

}

@end