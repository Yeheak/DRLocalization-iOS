//
//  DRAppDelegate.m
//  DRLocalizationDemo
//
//  Created by Dariusz Rybicki on 09.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRAppDelegate.h"
#import "DRLocalization.h"

@implementation DRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// load translations from JSON file
	NSString * path = [[NSBundle mainBundle] pathForResource:@"translations.json" ofType:nil];
	[[DRLocalization sharedInstance] loadFromJSONFile:path defaultLanguage:@"en"];
	
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	
}

@end
