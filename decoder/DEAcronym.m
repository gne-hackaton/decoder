//
//  DEAcronym.m
//  decoder
//
//  Created by Yuliang Ma on 6/7/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import "DEAcronym.h"

@implementation DEAcronym

@synthesize ac = _ac;
@synthesize data = _data;

#pragma mark - custom getters/setters
- (NSArray *) data {
    if (!_data) {
        _data = [[NSArray alloc] init];
    }
    
    return _data;
}


- (void) dealloc {
    [_ac release];
    [_data release];
    [super dealloc];
}

@end
