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

@synthesize medInfo;
@synthesize medicineSections;

- (IBAction)saveMedicine:(id)sender
{
    // Something is supposed to happen here!
    
    
    // Store Medicine Information
    NSArray *medicineContents = [medicineSections objectAtIndex:0];
    
    NSString *name = [[medicineContents objectAtIndex:0] stringValue];
    NSString *category = [[medicineContents objectAtIndex:1] stringValue];
    
    // Store Notes
    NSArray *notesArray = [medicineSections objectAtIndex:1];
    NSString *notes = [[notesArray objectAtIndex:0] stringValue];
    
    // Save the information
    //SironaLibraryItem *sli;
    SironaLibraryItem *sli = [[SironaLibraryItem alloc] initWithMDataBrand:name mdataCategory:category mdataId:@"" mdataName:@"" mdataPrecautions:@"" mdataSideEffects:@"" mdataNotes:notes];

    [medInfo addObject:sli];
    
    /*[sli initWithMDataBrand:name
         mdataCategory:category
         mdataId:@""
         mdataName:@""
         mdataPrecautions:@""
         mdataSideEffects:@""
         mdataNotes:notes];*/
    
    
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
    
    NSArray *sectionContents = [medicineSections objectAtIndex:[indexPath section]];
    NSString *rowContents = [sectionContents objectAtIndex:[indexPath row]];
    
    // Yes I did this with XIBs instead of programatically.
    
    if (!(rowContents == @"Notes")) {
        SironaTimeAddNewMedicineCell *slcv = [tableView dequeueReusableCellWithIdentifier:@"SironaTimeAddNewMedicineCell"];
        [[slcv cellLabel] setText:rowContents];
        return slcv;
    }
    
    else {
        SironaTimeAddNewMedicineNoteCell *stanmnc = [tableView dequeueReusableCellWithIdentifier:@"SironaTimeAddNewMedicineNoteCell"];
        return stanmnc;
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
    
    NSArray *sectionOne = [[NSArray alloc] initWithObjects:@"Name", @"Category", nil];
    NSArray *sectionTwo = [[NSArray alloc] initWithObjects:@"", nil];
    
    medicineSections = [[NSMutableArray alloc] initWithObjects:sectionOne, sectionTwo, nil];
    
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