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
    alertDays = days;
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

@end