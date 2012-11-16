//
//  SironaLibraryList.m
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaLibraryList.h"
#import "SironaLibraryItem.h"

@implementation SironaLibraryList

+ (SironaLibraryList *)sharedLibrary
{
    static SironaLibraryList *sharedLibrary = nil;
    if (!sharedLibrary)
        sharedLibrary = [[super allocWithZone:nil] init];
    return sharedLibrary;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedLibrary];    
}

- (id)init
{
    self = [super init];
    if (self) {
        allItems = [[NSMutableArray alloc] init];
    } return self;
}

- (NSArray *)allItems
{
    [allItems sortUsingSelector:@selector(compare:)];
    return allItems;
}

- (void)createItem:(SironaLibraryItem *)item;
{
    [allItems addObject:item];
}

@end
