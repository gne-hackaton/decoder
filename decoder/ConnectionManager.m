//
//  ConnectionManager.m
//  MobileVoicemail
//
//  Created by Yuliang Ma on 5/1/12.
//  Copyright (c) 2012 Genentech. All rights reserved.
//

#import "ConnectionManager.h"

@interface ConnectionManager () {
    Reachability* hostReach;
    Reachability* internetReach;
}

@property (nonatomic) int hostReachStatus;
@property (nonatomic) int internetReachStatus;

- (void)registerForObservingNetworkChange;
- (void)reachabilityChanged: (NSNotification *)note;
- (id) initConnectionManager;
@end

@implementation ConnectionManager
@synthesize hostReachStatus = _hostReachStatus;
@synthesize internetReachStatus = _internetReachStatus;
@synthesize connectivity = _connectivity;

static NSString * cConnectionChangedNotification = @"cConnectionChangedNotification";

- (void)setConnectivity:(ConnectivityType)connectivity {
    _connectivity = connectivity;
    
    NSNumber *connectivityObject = [NSNumber numberWithInt:connectivity];
    
    // Send out notification in the setter of model, could be used to for example, update UI when connection changes
	[[NSNotificationCenter defaultCenter] postNotificationName: cConnectionChangedNotification object: connectivityObject];
}

- (BOOL)hasInternetConnection {
    return (self.connectivity != kNoInternet);
}
- (BOOL)hasInternalInternetConnection {
    return (self.connectivity == kHasInternalConnection);
}

#pragma mark - singleton class method
+ (ConnectionManager *)sharedSingleton
{
	static ConnectionManager *sharedSingleton;
	
	@synchronized(self) {
		if (!sharedSingleton)
			sharedSingleton = [[ConnectionManager alloc] initConnectionManager];
        
		return sharedSingleton;
	}
}

#pragma mark - Designated initializer
- (id) initConnectionManager {
    if (self = [super init]) {
        [self registerForObservingNetworkChange];
    }
    return self;
}

#pragma mark - Reachability
- (void) updateConnectivityModel {
    if (self.internetReachStatus == NotReachable) 
        self.connectivity = kNoInternet;
    else {
        if (self.hostReachStatus == NotReachable)
            self.connectivity = kExternallyConnectedButNotInternally;
        else
            self.connectivity = kHasInternalConnection;
    }
}

- (void) updateModelWithReachability: (Reachability*) curReach {
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if(curReach == hostReach)
        self.hostReachStatus = netStatus;
    else if (curReach == internetReach) 
        self.internetReachStatus = netStatus;
	
    [self updateConnectivityModel];
}

- (void)registerForObservingNetworkChange {
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
	hostReach = [[Reachability reachabilityWithHostName: @"intranet.roche.com"] retain];
	[hostReach startNotifier];
    
    internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
    
	[self updateModelWithReachability: internetReach];
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note {
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateModelWithReachability: curReach];
}

@end
