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

- (id)init
{
	if (self = [super init]) {
		[self setupLocalization];
	}
	return self;
}

#pragma mark - UIApplicationDelegate methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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

#pragma mark - DRLocalization

- (void)setupLocalization
{
	// setup localization fallback
	[[DRLocalization sharedInstance] setUseSystemPreferredLanguages:YES];
	[[DRLocalization sharedInstance] setFallbackLanguage:@"en"];
	
	// include localizations from system localized strings
	[[DRLocalization sharedInstance] addLocalizationStore:[[DRLocalizationStandardStore alloc] init]];
	
	// include localizations from JSON file - English
	[[DRLocalization sharedInstance] addLocalizationStore:
	 [[DRLocalizationJSONFileStore alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"strings_en.json" ofType:nil]
									 andSupportedLanguages:@[ @"en" ]]];
	
	// include localizations from JSON file - Polish
	[[DRLocalization sharedInstance] addLocalizationStore:
	 [[DRLocalizationJSONFileStore alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"strings_pl.json" ofType:nil]
									 andSupportedLanguages:@[ @"pl" ]]];
	
	// include localizations from JSON file - German
	[[DRLocalization sharedInstance] addLocalizationStore:
	 [[DRLocalizationJSONFileStore alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"strings_de.json" ofType:nil]
									 andSupportedLanguages:@[ @"de" ]]];
}

@end
