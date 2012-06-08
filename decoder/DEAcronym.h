//
//  DEAcronym.h
//  decoder
//
//  Created by Yuliang Ma on 6/7/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEAcronym : NSObject

@property (nonatomic, copy) NSString *dict;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *def;
@property (nonatomic, copy) NSString *name;

+ (id)acronymWithName: (NSString *)name dict:(NSString *)dict identifier:(NSString *)ID definition:(NSString *)def;
- (id)initWithName:(NSString *)name dict:(NSString *)dct identifer:(NSString *)identifier definition:(NSString *)definition;

@end
