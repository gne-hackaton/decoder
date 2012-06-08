//
//  DERecentsStorage.m
//  decoder
//
//  Created by Maciej Skolecki on 6/8/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import "DERecentsStorage.h"

#define RECENTS_STORE_ARCHIVE_KEY @"DERecentsStorage_store"
#define RECENTS_SIZE_ARCHIVE_KEY @"DERecentsStorage_size"

@implementation DERecentsStorage

@dynamic recents;

- (id)initStore {
	return [[DERecentsStorage alloc] initStoreWithSize:DEFAULT_RECENTS_STORE_SIZE];
}

- (id)initStoreWithSize:(int)s {
	if ((self = [super init])) {
		store = [[NSMutableArray alloc] init];
		size = s;
	}
	return self;
}


- (void)dealloc {
	[store release];
	[super dealloc];
}

-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject: store forKey: RECENTS_STORE_ARCHIVE_KEY];
	[encoder encodeInt: size forKey: RECENTS_SIZE_ARCHIVE_KEY];
}

-(id)initWithCoder:(NSCoder *)decoder {
	store = [[decoder decodeObjectForKey: RECENTS_STORE_ARCHIVE_KEY] retain];
	size = [decoder decodeIntForKey: RECENTS_SIZE_ARCHIVE_KEY];
	return self;
}

- (void)addRecent:(DEAcronym *)recent {
	[store removeObject: recent];
	[store insertObject:recent atIndex:0];
	if ([store count] > size) {
		[store removeLastObject];
	}
	
}

- (NSArray *)recents {
	return [NSArray arrayWithArray:store];
}

- (BOOL)isEmpty {
	return [store count] == 0;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"size: %d, contents:%@", size, store];
}



@end
