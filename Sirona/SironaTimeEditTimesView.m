//
//  SironaTimeEditTimesView.m
//  Sirona
//
//  Created by Roger Chen on 11/12/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaTimeEditTimesView.h"
#import "SironaTimeAddTimeView.h"

@implementation SironaTimeEditTimesView

@synthesize item;

- (IBAction)addTime:(id)sender
{
    SironaTimeAddTimeView *statv = [[SironaTimeAddTimeView alloc] init];
    [statv setAlertTimes:[item getAlertTimes]];
    [[self navigationController] pushViewController:statv animated:YES];
}

// Returns the count of the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[item getAlertTimes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString *time = [[item getAlertTimes] objectAtIndex:[indexPath row]];    
    cell.textLabel.text = time;
    return cell;
}

// Prevents times from being tapped
- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)removeTime:(NSString *)time
{
    [[item getAlertTimes] removeObject:time];
    [self.tableView reloadData];
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeTime:[[item getAlertTimes] objectAtIndex:[indexPath row]]];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        self.title = @"Times";
        
        // Bar button for "Add"
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addTime:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        
    }
    
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

@end
