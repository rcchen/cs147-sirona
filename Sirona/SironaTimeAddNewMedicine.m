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
@synthesize placeholderText;
@synthesize item;
@synthesize alertList;

- (void)setMedicines:(NSMutableArray *)medicines
{
    medicineSections = medicines;
}

- (IBAction)saveMedicine:(id)sender
{
    
    NSString *name = [[textFields objectAtIndex:0] text];
    // Checks the name field, which cannot be blank. Shows an alert if it is.
    if ([(UITextField *)[textFields objectAtIndex:0] textColor] == [UIColor lightGrayColor] || [name length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Saving"
                                                        message:@"Medication name cannot be blank"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

    NSMutableArray *userAnswers = [[NSMutableArray alloc] init];
    for (int i = 0; i < 13; i++)
        [userAnswers addObject:@""];
    
    NSLog(@"Got here");
    
    for (int i = 0; i < [textFields count]; i++) {
        NSString *answer = [[textFields objectAtIndex:i] text];
        // If answer is blank somehow or if only filled with placeholder
        if ([answer length] == 0 || (i != 12 && [(UITextField *)[textFields objectAtIndex:i] textColor] == [UIColor lightGrayColor]))
            answer = @"";
        [userAnswers replaceObjectAtIndex:i withObject:answer];
    }
    
    // Save the information
    SironaLibraryItem *sli = [[SironaLibraryItem alloc] initWithMDataName:[userAnswers objectAtIndex:0] mdataDosage:[userAnswers objectAtIndex:1] mdataRoute:[userAnswers objectAtIndex:2] mdataForm:[userAnswers objectAtIndex:3] mdataQuantity:[userAnswers objectAtIndex:4] mdataFor:[userAnswers objectAtIndex:5] mdataInstructions:[userAnswers objectAtIndex:6] mdataPrecautions:[userAnswers objectAtIndex:7] mdataSideEffects:[userAnswers objectAtIndex:8] mdataPharmacyPhone:[userAnswers objectAtIndex:9] mdataPharmacy:[userAnswers objectAtIndex:10] mdataDoctor:[userAnswers objectAtIndex:11] mdataNotes:[userAnswers objectAtIndex:12]];
    
    [item setLibraryItem:sli];
    
    // Now save the new medication to NSUserDefaults
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
    
    // Set the updated alerts from NSUserDefaults
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([indexPath section] != 2) { // Info sections
        UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(110, 8, 200, 30)];
        inputField.adjustsFontSizeToFitWidth = NO;
        [cell addSubview:inputField];
        [inputField setDelegate:self];
        inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        inputField.keyboardType = UIKeyboardTypeDefault;
        
        // sets tag of the inputField equal to the global row across sections
        inputField.tag = [indexPath section] * 5 + [indexPath row];

        // sets the placeholder text initially
        inputField.text = [placeholderText objectAtIndex:inputField.tag];
        inputField.textColor = [UIColor lightGrayColor];
        inputField.font = [UIFont italicSystemFontOfSize:14];
        
        [textFields addObject:inputField];
        
        cell.textLabel.text = [[medicineSections objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    } else { // Notes section
        UITextView *inputField = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, 280, 260)];
        inputField.backgroundColor = [UIColor clearColor];
        [cell addSubview:inputField];
        inputField.font = [UIFont fontWithName:@"Helvetica" size:14];
        
        [textFields addObject:inputField];
        
        // Sets tag equal to index of the last entry
        //inputField.tag = [placeholderText count] - 1;
    }
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    return cell;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // If there is currently placeholder text, then change to input text
    if (textField.textColor == [UIColor lightGrayColor]) {
        textField.text = @"";
        textField.textColor = [UIColor blackColor];
        textField.font = [UIFont fontWithName:@"Helvetica" size:14];
    }
}

// Once editing for a textfield is done, checks whether placeholder text should be added
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([textField.text length] == 0) {
        textField.text = [placeholderText objectAtIndex:textField.tag];
        textField.textColor = [UIColor lightGrayColor];
        textField.font = [UIFont italicSystemFontOfSize:14];
    }
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
    if (section == 0) {
        return @"Basic Info";
    } else if (section == 1) {
        return @"Additional Info";
    } else { // third section
        return @"Notes";
    }
}

// Makes the white box for the Notes section taller
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 2) {
        return 280.0f;
    } return 44.0f;
}

- (id)init {
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
    
    NSArray *sectionOne = [[NSArray alloc] initWithObjects:@"Name", @"Dosage", @"Route", @"Form", @"Quantity", nil];
    NSArray *sectionTwo = [[NSArray alloc] initWithObjects:@"For", @"Instructions", @"Precautions", @"Side effects", @"Pharmacy #", @"Pharmacy", @"Doctor", nil];
    NSArray *sectionThree = [[NSArray alloc] initWithObjects:@"Notes", nil];
    
    medicineSections = [[NSArray alloc] initWithObjects:sectionOne, sectionTwo, sectionThree, nil];
    
    textFields = [[NSMutableArray alloc] init];
    
    placeholderText = [[NSArray alloc] initWithObjects:@"name of the medication", @"e.g. 1 pill", @"e.g. oral, topical, etc.", @"e.g. pill, syrup, spray, etc.", @"current total quantity", @"who the med is for", @"e.g. take with food", @"e.g. avoid alcohol", @"e.g. dizziness, nausea, etc.", @"XXX-XXX-XXXX", @"the refill pharmacy", @"the prescribing doctor", nil];
    
    self.editing = NO;
    
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
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

    UINib *nib3 = [UINib nibWithNibName:@"SironaTimeAddNewMedicineNoteCell" bundle:nil];
    [[self tableView] registerNib:nib3 forCellReuseIdentifier:@"SironaTimeAddNewMedicineNoteCell"];
}

@end