//
//  SironaMedicationDetailedViewController.m
//  Sirona
//
//  Created by Catherine Lu on 11/28/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaMedicationDetailedViewController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation SironaMedicationDetailedViewController

@synthesize medicineSections;
@synthesize textFields;
@synthesize placeholderText;
@synthesize inputtedText;
@synthesize item;
@synthesize alertList;

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
    
    for (int i = 0; i < [textFields count]; i++) {
        NSString *answer = [[textFields objectAtIndex:i] text];
        // If answer is blank somehow or if only filled with placeholder
        if ([answer length] == 0 || (i != [textFields count] - 1 && [(UITextField *)[textFields objectAtIndex:i] textColor] == [UIColor lightGrayColor]))
            answer = @"";
        [userAnswers replaceObjectAtIndex:i withObject:answer];
    }
    
    // Save the new medication to NSUserDefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *encodedCustomMedList = [prefs objectForKey:@"customMedList"];
    NSMutableArray *customMeds = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedCustomMedList];
    // Removes the old item
    for (SironaLibraryItem* i in customMeds) {
        if ([[i getId] isEqualToString:[item getId]]) {
            [customMeds removeObjectIdenticalTo:i];
            break;
        }
    }
        
    // Create updated item
    SironaLibraryItem* newItem = [[SironaLibraryItem alloc] initWithMDataName:[userAnswers objectAtIndex:0] mdataDosage:[userAnswers objectAtIndex:1] mdataRoute:[userAnswers objectAtIndex:2] mdataForm:[userAnswers objectAtIndex:3] mdataQuantity:[userAnswers objectAtIndex:4] mdataFor:[userAnswers objectAtIndex:5] mdataInstructions:[userAnswers objectAtIndex:6] mdataPrecautions:[userAnswers objectAtIndex:7] mdataSideEffects:[userAnswers objectAtIndex:8] mdataPharmacyPhone:[userAnswers objectAtIndex:9] mdataPharmacy:[userAnswers objectAtIndex:10] mdataDoctor:[userAnswers objectAtIndex:11] mdataNotes:[userAnswers objectAtIndex:12]];
    
    // Update the med list
    [customMeds addObject:newItem];
    encodedCustomMedList = [NSKeyedArchiver archivedDataWithRootObject:customMeds];
    [prefs setObject:encodedCustomMedList forKey:@"customMedList"];
    
    
    // Set the updated alerts from NSUserDefaults
    NSData *encodedAlertList = [prefs objectForKey:@"alertList"];
    if (encodedAlertList) {
        NSMutableArray *prefAlerts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedAlertList];
        alertList = prefAlerts;
    }
    
    // Update alerts that use this medication
    for (SironaAlertItem *sai in alertList) {        
        if ([[[sai getLibraryItem] getId] isEqualToString:[item getId]]) {
            NSLog(@"Updating alert");
            [sai setLibraryItem:newItem];
        }
    }
    
    // Now save it to NSUserDefaults
    encodedAlertList = [NSKeyedArchiver archivedDataWithRootObject:alertList];
    [prefs setObject:encodedAlertList forKey:@"alertList"];
    
    item = newItem;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved"
                                                    message:[NSString stringWithFormat:@"%@ has been saved", [item getName]]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
        
        
        NSString *previousEntry;
        if ([[inputtedText objectAtIndex:inputField.tag] length] > 0) {
            previousEntry = [inputtedText objectAtIndex:inputField.tag];
        } else {
            switch (inputField.tag) {
                case 0:
                    previousEntry = [item getName];
                    break;
                case 1:
                    previousEntry = [item getDosage];
                    break;
                case 2:
                    previousEntry = [item getRoute];
                    break;
                case 3:
                    previousEntry = [item getForm];
                    break;
                case 4:
                    previousEntry = [item getQuantity];
                    break;
                case 5:
                    previousEntry = [item getFor];
                    break;
                case 6:
                    previousEntry = [item getInstructions];
                    break;
                case 7:
                    previousEntry = [item getPrecautions];
                    break;
                case 8:
                    previousEntry = [item getSideEffects];
                    break;
                case 9:
                    previousEntry = [item getPharmacyPhone];
                    break;
                case 10:
                    previousEntry = [item getPharmacy];
                    break;
                case 11:
                    previousEntry = [item getDoctor];
                    break;
                default:
                    NSLog(@"Default");
                    break;
            }
        }
        if (previousEntry.length == 0) {
            previousEntry = [placeholderText objectAtIndex:inputField.tag];
            inputField.textColor = [UIColor lightGrayColor];
            inputField.font = [UIFont italicSystemFontOfSize:14];
        } else {
            inputField.font = [UIFont fontWithName:@"Helvetica" size:14];
        }
        
        // sets the placeholder text initially
        inputField.text = previousEntry;
        
        [textFields replaceObjectAtIndex:inputField.tag withObject:inputField];
        
        cell.textLabel.text = [[medicineSections objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    } else { // Notes section
        UITextView *inputField = [[UITextView alloc] initWithFrame:CGRectMake(15, 5, 280, 260)];
        inputField.backgroundColor = [UIColor clearColor];
        [cell addSubview:inputField];
        inputField.font = [UIFont fontWithName:@"Helvetica" size:14];
        inputField.tag = 12;
        [inputField setDelegate:self];

        if ([[inputtedText objectAtIndex:12] length] > 0)
            inputField.text = [inputtedText objectAtIndex:12];
        else
            inputField.text = [item getNotes];
        
        [textFields replaceObjectAtIndex:12 withObject:inputField];
        
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
    } else {
        [inputtedText replaceObjectAtIndex:textField.tag withObject:textField.text];
    }
    [textFields replaceObjectAtIndex:textField.tag withObject:textField];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text length] > 0)
        [inputtedText replaceObjectAtIndex:12 withObject:textView.text];
    [textFields replaceObjectAtIndex:textView.tag withObject:textView];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// THIS DOESN'T EVEN BRING UP THE RED DELETE BUTTON...
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // TODO: implement this
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    
}

- (id)init {
    if (self) {
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                target:self
                                action:@selector(saveMedicine:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        self.title = [item getName];
        
    }
    
    NSArray *sectionOne = [[NSArray alloc] initWithObjects:@"Name", @"Dosage", @"Route", @"Form", @"Quantity", nil];
    NSArray *sectionTwo = [[NSArray alloc] initWithObjects:@"For", @"Instructions", @"Precautions", @"Side effects", @"Pharmacy #", @"Pharmacy", @"Doctor", nil];
    NSArray *sectionThree = [[NSArray alloc] initWithObjects:@"Notes", nil];
    
    medicineSections = [[NSArray alloc] initWithObjects:sectionOne, sectionTwo, sectionThree, nil];
    
    textFields = [[NSMutableArray alloc] init];
    for (int i = 0; i < 13; i++)
        [textFields addObject:[[UITextField alloc] init]];
    
    placeholderText = [[NSArray alloc] initWithObjects:@"name of the medication", @"e.g. 1 pill", @"e.g. oral, topical, etc.", @"e.g. pill, syrup, spray, etc.", @"current total quantity", @"who the med is for", @"e.g. take with food", @"e.g. avoid alcohol", @"e.g. dizziness, nausea, etc.", @"XXX-XXX-XXXX", @"the refill pharmacy", @"the prescribing doctor", nil];
    
    inputtedText = [[NSMutableArray alloc] init];
    for (int i = 0; i < 13; i++)
        [inputtedText addObject:@""];
    
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