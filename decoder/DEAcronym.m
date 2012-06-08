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

- (id)initWithDict:(NSString *)dct id:(NSString *)identifier def:(NSString *)definition {
	if ((self = [super init])) {
		self.dict = dct;
		self.ID = identifier;
		self.def = definition;
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"dict: %@, ID: %@, def: %@", _dict, _ID, _def];
}

@end
