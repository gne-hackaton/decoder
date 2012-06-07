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


- (void) dealloc {
    [_dict release];
    [_ID release];
    [_def release];
    [super dealloc];
}

@end
