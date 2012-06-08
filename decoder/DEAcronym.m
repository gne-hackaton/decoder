//
//  DEAcronym.m
//  decoder
//
//  Created by Yuliang Ma on 6/7/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import "DEAcronym.h"

#define ACRONYM_DICT_ARCHIVE_KEY @"DEAcronym_dict"
#define ACRONYM_ID_ARCHIVE_KEY @"DEAcronym_id"
#define ACRONYM_DEF_ARCHIVE_KEY @"DEAcronym_def"
#define ACRONYM_NAME_ARCHIVE_KEY @"DEAcronym_name"


@implementation DEAcronym

@synthesize dict = _dict;
@synthesize ID = _ID;
@synthesize def = _def;
@synthesize name = _name;



+ (id)acronymWithName: (NSString *)name dict:(NSString *)dict identifier:(NSString *)ID definition: (NSString *)def {
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

- (id)initWithName:(NSString *)name dict:(NSString *)dct identifer:(NSString *)identifier definition:(NSString *)definition {
	if ((self = [super init])) {
		self.dict = dct;
		self.ID = identifier;
		self.def = definition;
		self.name = name;
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject: _dict forKey: ACRONYM_DICT_ARCHIVE_KEY];
	[encoder encodeObject: _ID forKey: ACRONYM_ID_ARCHIVE_KEY];
	[encoder encodeObject: _def forKey: ACRONYM_DEF_ARCHIVE_KEY];
	[encoder encodeObject: _name forKey: ACRONYM_NAME_ARCHIVE_KEY];
}

-(id)initWithCoder:(NSCoder *)decoder {
	_dict = [[decoder decodeObjectForKey: ACRONYM_DICT_ARCHIVE_KEY] retain];
	_ID = [[decoder decodeObjectForKey: ACRONYM_ID_ARCHIVE_KEY] retain];
	_def = [[decoder decodeObjectForKey: ACRONYM_DEF_ARCHIVE_KEY] retain];
	_name = [[decoder decodeObjectForKey: ACRONYM_NAME_ARCHIVE_KEY] retain];
	return self;
}


-(BOOL)isEqual:(id)anObject {
	if(!([[self class] isEqual: [anObject class]]))
	   return NO;
	DEAcronym *ac = (DEAcronym *)anObject;

	if(!([_dict isEqual: ac.dict]) || 
	   !([_ID isEqual: ac.ID]) || 
	   !([_def isEqual: ac.def]) || 
	   !([_name isEqual: ac.name]))
	   return NO;

	return YES;
}


- (NSString *)description {
	return [NSString stringWithFormat:@"name: %@, dict: %@, ID: %@, def: %@",_name,  _dict, _ID, _def];
}

@end
