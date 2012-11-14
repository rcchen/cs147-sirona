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

@implementation SironaTimeAddNewMedicine

@synthesize medInfo;
@synthesize medicineSections;

- (IBAction)saveMedicine:(id)sender
{
    // Something is supposed to happen here!
    
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
        
        self.title = @"Add medicine";
        
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