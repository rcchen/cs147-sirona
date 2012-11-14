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
              mdataNotes: (NSString *)notes
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

- (NSString *)getCategory
{
    return mdataCategory;
}

- (NSString *)getId
{
    return mdataId;
}

- (NSString *)getPrecautions
{
    return mdataPrecautions;
}

- (NSString *)getSideEffects
{
    return mdataSideEffects;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:mdataBrand forKey:@"mdataBrand"];
    [encoder encodeObject:mdataCategory forKey:@"mdataCategory"];
    [encoder encodeObject:mdataId forKey:@"mdataId"];
    [encoder encodeObject:mdataName forKey:@"mdataName"];
    [encoder encodeObject:mdataPrecautions forKey:@"mdataPrecautions"];
    [encoder encodeObject:mdataSideEffects forKey:@"mdataSideEffects"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        mdataBrand = [decoder decodeObjectForKey:@"mdataBrand"];
        mdataCategory = [decoder decodeObjectForKey:@"mdataCategory"];
        mdataId = [decoder decodeObjectForKey:@"mdataId"];
        mdataName = [decoder decodeObjectForKey:@"mdataName"];
        mdataPrecautions = [decoder decodeObjectForKey:@"mdataPrecautions"];
        mdataSideEffects = [decoder decodeObjectForKey:@"mdataSideEffects"];
    } return self;
}


@end
