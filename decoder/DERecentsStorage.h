//
//  DERecentsStorage.h
//  decoder
//
//  Created by Maciej Skolecki on 6/8/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEAcronym.h"

#define DEFAULT_RECENTS_STORE_SIZE 10


@interface DERecentsStorage : NSObject<NSCoding> {

	int size;
	NSMutableArray *store;

}

@property (nonatomic, retain, readonly) NSArray *recents;

- (id)initStore;
- (id)initStoreWithSize:(int)s;
- (void)addRecent:(DEAcronym *)recent;
- (BOOL)isEmpty;

@end
