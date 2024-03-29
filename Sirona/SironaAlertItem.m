//
//  SironaAlertItem.m
//  Sirona
//
//  Created by Roger Chen on 11/9/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaAlertItem.h"

@implementation SironaAlertItem

- (id)init {
    
    // After initiating with the NSObject alloc, init the individual properties
    if (self = [super init]) {
        alertDays = [[NSMutableArray alloc] init];
        alertTimes = [[NSMutableArray alloc] init];
        alertID = [[NSString alloc] init];
        saved = NO;
    }
    
    // Return pointer to the object
    return self;
    
}

- (SironaLibraryItem *)getLibraryItem {
    return sli;
}

- (NSMutableArray *)getAlertDays {
    return alertDays;
}

- (NSMutableArray *)getAlertTimes {
    return alertTimes;
}

- (void)setLibraryItem:(SironaLibraryItem *)item {
    sli = item;
}

- (void)setAlertDays:(NSMutableArray*)days {
    
    // Sort the alert days from Sunday to Saturday
    NSMutableArray *newAlertDays = [[NSMutableArray alloc] init];
    if ([alertDays containsObject:@"Sunday"]) {
        [newAlertDays addObject:@"Sunday"];
    }
    if ([alertDays containsObject:@"Monday"]) {
        [newAlertDays addObject:@"Monday"];
    }
    if ([alertDays containsObject:@"Tuesday"]) {
        [newAlertDays addObject:@"Tuesday"];
    }
    if ([alertDays containsObject:@"Wednesday"]) {
        [newAlertDays addObject:@"Wednesday"];
    }
    if ([alertDays containsObject:@"Thursday"]) {
        [newAlertDays addObject:@"Thursday"];
    }
    if ([alertDays containsObject:@"Friday"]) {
        [newAlertDays addObject:@"Friday"];
    }
    if ([alertDays containsObject:@"Saturday"]) {
        [newAlertDays addObject:@"Saturday"];
    }
    
    alertDays = newAlertDays;
}

- (void)setAlertTimes:(NSMutableArray*)times {
    alertTimes = times;
}

- (NSString*)getAlertId {
    return alertID;
}

- (void)setAlertId
{
    if (![alertID length]) {
        NSDate *now = [[NSDate alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
        alertID = [formatter stringFromDate:now];
    }
    
}

- (NSComparisonResult)compare:(SironaAlertItem *)otherObject {
    return self.getLibraryItem.getName.length - otherObject.getLibraryItem.getName.length;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:alertDays forKey:@"alertDays"];
    [encoder encodeObject:alertTimes forKey:@"alertTimes"];
    [encoder encodeObject:sli forKey:@"alertLibraryItem"];
    [encoder encodeObject:alertID forKey:@"alertID"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        alertDays = [decoder decodeObjectForKey:@"alertDays"];
        alertTimes = [decoder decodeObjectForKey:@"alertTimes"];
        sli = [decoder decodeObjectForKey:@"alertLibraryItem"];
        alertID = [decoder decodeObjectForKey:@"alertID"];
    }
    return self;
}

- (void)setSaved {
    saved = YES;
    NSLog(@"SAVED");
}

- (BOOL)isSaved {
    return saved;
}

@end