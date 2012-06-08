//
//  AppDelegate.m
//  decoder
//
//  Created by Maciej Skolecki on 6/7/12.
//  Copyright (c) 2012 Roche. All rights reserved.
//
#import "AppDelegate.h"

@interface AppDelegate(){
	@private
	UISplitViewController *_splitViewController;
	UITabBarController *_tabBarController;
	}

- (void)initialConfiguration;
@end

@implementation AppDelegate
@synthesize window = _window;

- (void)dealloc
{
	[_splitViewController release];
	[_tabBarController release];
	[_window release];
	[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	// Override point for customization after application launch.
	self.window.backgroundColor = [UIColor whiteColor];
	[self initialConfiguration];
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)initialConfiguration{
	_tabBarController = [[UITabBarController alloc] init];
	
	UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
	UITabBarItem *favItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
	UITabBarItem *recentsItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:2];
	
	
	UITableViewController *acronymsListTableViewController = [[UITableViewController alloc] 
																														initWithStyle:UITableViewStylePlain];
	
	UIViewController *favViewController = [[UIViewController alloc] init];
	UIViewController *recentsViewController = [[UIViewController alloc] init];
	
	
	UINavigationController *homeNavigationController = [[UINavigationController alloc] 
																											initWithRootViewController:acronymsListTableViewController];
	[homeNavigationController setTabBarItem:homeItem];
	
	
	UINavigationController *favNavigationController = [[UINavigationController alloc] initWithRootViewController:favViewController];
	[favNavigationController setTabBarItem:favItem];
	
	UINavigationController *recentsNavigationController = [[UINavigationController alloc] initWithRootViewController:recentsViewController];
	[recentsNavigationController setTabBarItem:recentsItem];
	
	
	NSMutableArray *navBarElements = [NSMutableArray arrayWithObjects:homeNavigationController,favNavigationController,
																		recentsNavigationController,nil];
	
	[_tabBarController setViewControllers:navBarElements];
	[[self window] setRootViewController:_tabBarController];
	
	[acronymsListTableViewController release];
	[favViewController release];
	[recentsViewController release];
	
	[homeNavigationController release];
	[favNavigationController release];
	[recentsNavigationController release];
	
	[homeItem release];
	[favItem release];
	[recentsItem release];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
