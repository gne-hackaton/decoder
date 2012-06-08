//
//  ConnectionManager.h
//  MobileVoicemail
//
//  Created by Yuliang Ma on 5/1/12.
//  Copyright (c) 2012 Genentech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ConnectionManager : NSObject 
typedef enum {
    kNoInternet,
    kExternallyConnectedButNotInternally,
    kHasInternalConnection
} ConnectivityType;

- (BOOL)hasInternetConnection;

@property (nonatomic) ConnectivityType connectivity;

+ (ConnectionManager *)sharedSingleton;

@end
