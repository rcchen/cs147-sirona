//
//  SironaLibraryList.h
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SironaLibraryItem;

@interface SironaLibraryList : NSObject
{
    NSMutableArray *allItems;
}

+ (SironaLibraryList *)sharedLibrary;

- (NSArray *)allItems;
- (void)createItem:(SironaLibraryItem *)item;

@end
