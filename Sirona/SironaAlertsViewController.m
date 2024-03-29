//
//  SironaAlertsViewController.m
//  Sirona
//
//  Created by Roger Chen on 11/14/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaAlertsViewController.h"
#import "SironaTimeCellView.h"
#import "SironaTimeEditAlertView.h"
#import "SironaAlertItem.h"

@implementation SironaAlertsViewController

@synthesize alertsTable;
@synthesize alertList;

- (id) init
{
    
    self = [super init];
    
    if (self) {
        
        // Get the tab bar item and give it a label
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Alerts"];
        
        // Now give it an image
        UIImage *i = [UIImage imageNamed:@"10-medical.png"];
        [tbi setImage:i];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:NSLocalizedString(@"Alerts", @"Application title")];
        
        // Create a new bar button item that will send addNewItem: to ItemsViewController
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        // Add edit button to the left
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
        [self initializeAlerts];
    }
    return self;
    
}

// sets the editing that occurs when Edit is pressed
- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated: animated];
    [alertsTable setEditing:editing animated:animated];
}

- (void)initializeAlerts
{
    alertList = [[SironaAlertList alloc] init];
    [alertList removeUnsaved];
}

- (void)viewDidLoad
{
    
    NSLog(@"Loading this view");
    
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated
{
 
    NSLog(@"Appearing this view");
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self initializeAlerts];
    
    // Programatically add a tableView to the thing
    alertsTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    UINib *nib = [UINib nibWithNibName:@"SironaTimeCellView" bundle:nil];
    [alertsTable registerNib:nib forCellReuseIdentifier:@"SironaTimeCellView"];
    self.alertsTable.dataSource = self;
    self.alertsTable.delegate = self;
    self.alertsTable.allowsSelection = NO;
    self.alertsTable.allowsSelectionDuringEditing = YES;
    alertsTable.frame = CGRectMake(0, 70, self.view.bounds.size.width, self.view.bounds.size.height); // HACKHACK
    [alertsTable reloadData];
    [self.view addSubview:alertsTable];
    
    for (SironaAlertItem *alertItem in [alertList allAlerts]) {
        [self setAllAlarms:alertItem];
    }
    
    for (UILocalNotification *old in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSLog(@"Alert for %@ at %@", [old.userInfo objectForKey:@"alertID"], [old fireDate]);
    }
    
    if (![alertList count]) {
        // Handles the overlay
        UIViewController* c = [[UIViewController alloc] initWithNibName:@"SironaAlertNoneView" bundle:nil];
        UIView *overlayNone = [c view];
        overlayNone.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.view addSubview:overlayNone];
    }

    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92.0f;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [alertList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SironaTimeCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"SironaTimeCellView"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SironaTimeCellView" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = (SironaTimeCellView *)[topLevelObjects objectAtIndex:0];
    }

    SironaAlertItem *sai = [alertList objectAtIndex:[indexPath row]];
    [[cell cellMain] setText:[[sai getLibraryItem] getName]];
    [[cell cellSecondary] setText:[[sai getLibraryItem] getDosage]];
    
    NSMutableString *tertiaryText = [[NSMutableString alloc] init];
    if ([[sai getAlertDays] count] == 0)
        [[cell cellTertiary] setText:@"No days set"];
    else {
        for (NSString *day in [sai getAlertDays]) {
            [tertiaryText appendFormat:@"%@ ", [day substringToIndex:3]];
        } [[cell cellTertiary] setText:tertiaryText];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SironaTimeEditAlertView *stevc = [[SironaTimeEditAlertView alloc] init];
    SironaAlertItem *selectedItem = [alertList objectAtIndex:[indexPath row]];
    [stevc setItem:selectedItem];
    [[self navigationController] pushViewController:stevc animated:YES];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [alertList removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
    
}


- (IBAction)addNewItem:(id)sender
{
    SironaTimeEditAlertView *stevc = [[SironaTimeEditAlertView alloc] init];
    SironaAlertItem *newItem = [[SironaAlertItem alloc] init];
    [newItem setAlertId];
    [stevc setItem:newItem];
    [[self navigationController] pushViewController:stevc animated:YES];
    
}


- (void)setAllAlarms:(SironaAlertItem *)alertItem
{
    
    // First delete all of the alarms associated with the alertItem
    for (UILocalNotification *old in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        
        // Cancel anything that matches the alertID
        if ([[old.userInfo objectForKey:@"alertID"] isEqualToString:[alertItem getAlertId]]) {
            [[UIApplication sharedApplication] cancelLocalNotification:old];
        }
        
    }
    
    // Then add all of the alerts back in
    NSArray *daysOfWeek = [[NSArray alloc] initWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    
    // Create nextFireDate which has the time from time but the correct
    // day of the week from day.
    for (NSDate *time in [alertItem getAlertTimes]) {
        
        for (NSString *day in [alertItem getAlertDays]) {
            
            // First create an NSDate with the correct day/month/year
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            // Writes out entire day e.g. Friday
            NSDate *date = [NSDate date];
            NSString *todaysDay = [dateFormatter stringFromDate:date];
            
            int dayDifference = [daysOfWeek indexOfObject:day] - [daysOfWeek indexOfObject:todaysDay];
            if (dayDifference < 0) dayDifference += 7;
            date = [date dateByAddingTimeInterval:60*60*24*dayDifference];
            
            // Now combine the date portion from date with the time portion from time
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
            NSDateComponents *comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:date];
            NSDate *nextFireDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
            
            unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:time];
            nextFireDate = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:nextFireDate options:0];
            
            NSMutableString *alertBody = [[NSMutableString alloc] init];
            [alertBody appendFormat:@"Time to take your %@", [[alertItem getLibraryItem] getName]];
            
            // Create and set properties of the UILocalNotification
            UILocalNotification *notif = [[UILocalNotification alloc] init];
            notif.repeatInterval = NSWeekCalendarUnit;
            notif.alertBody = alertBody;
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.fireDate = nextFireDate;
            notif.alertAction = @"View";
            notif.soundName = UILocalNotificationDefaultSoundName;
            notif.applicationIconBadgeNumber += 1;
            
            // Use this code to store the ID in the userInfo dictionary
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[alertItem getAlertId], @"alertID", nil];
            notif.userInfo = dict;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
            
        }
        
    }
    
}

@end
