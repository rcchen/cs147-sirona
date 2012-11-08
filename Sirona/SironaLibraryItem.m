//
//  SironaLibraryItem.m
//  Sirona
//
//  Created by Roger Chen on 11/8/12.
//  Copyright (c) 2012 Roger Chen. All rights reserved.
//

#import "SironaLibraryItem.h"

@implementation SironaLibraryItem

- (id)initWithMDataBrand: (NSString *)jsonBrand
           mdataCategory: (NSString *)jsonCategory
                 mdataId: (NSString *)jsonId
               mdataName: (NSString *)jsonName
        mdataPrecautions: (NSString *)jsonPrecautions
        mdataSideEffects: (NSString *)jsonSideEffects
{
    
    mdataBrand = jsonBrand;
    mdataCategory = jsonCategory;
    mdataId = jsonId;
    mdataName = jsonName;
    mdataPrecautions = jsonPrecautions;
    mdataSideEffects = jsonSideEffects;
    
    return self;
    
}

- (NSString *)getBrand
{
    return mdataBrand;
}

- (void)setBrand:(NSString *)brand;
{
    mdataBrand = brand;
}

- (NSString *)getCategory
{
    return mdataCategory;
}

- (void)setCategory:(NSString *)category;
{
    mdataCategory = category;
}

@end
