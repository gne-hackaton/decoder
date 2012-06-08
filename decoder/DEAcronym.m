//
//  DEAcronym.m
//  decoder
//
//  Created by Yuliang Ma on 6/7/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import "DEAcronym.h"

@implementation DEAcronym

@synthesize dict = _dict;
@synthesize ID = _ID;
@synthesize def = _def;
@synthesize name = _name;

+ (id)acronymWithName: (NSString *)name dict: (NSString *)dict ID: (NSString *)ID definition: (NSString *)def {
    DEAcronym *acronym = [[[DEAcronym alloc] init] autorelease];
    acronym.dict = dict;
    acronym.ID = ID;
    acronym.def = def;
    acronym.name = name;
    
    return acronym;
}

- (void) dealloc {
    [_name release];
    [_dict release];
    [_ID release];
    [_def release];
    [super dealloc];
}

@end
