//
//  DRLocalization.m
//  DRLocalization
//
//  Created by Dariusz Rybicki on 24.06.2013.
//  Copyright (c) 2013 Darrarski. All rights reserved.
//

#import "DRLocalization.h"

static NSString *DRLocalizationCurrentLanguageUserDefaultsKey = @"DRLocalizationCurrentLanguage";

@implementation DRLocalization
{
	NSString *_currentLanguage;
}

+ (instancetype)sharedInstance
{
	__strong static id sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (id)init
{
	if (self = [super init]) {
		_persistCurrentLanguage = YES;
	}
	return self;
}

#pragma mark - Localization stores

- (NSArray *)localizationStores
{
	if (!_localizationStores) {
		_localizationStores = [[NSArray alloc] init];
	}
	return _localizationStores;
}

- (void)addLocalizationStore:(id<DRLocalizationStore>)localizationStore
{
	self.localizationStores = [@[localizationStore] arrayByAddingObjectsFromArray:self.localizationStores];
}

#pragma mark - Languages

- (NSOrderedSet *)supportedLanguages
{
	NSMutableOrderedSet *supportedLanguages = [[NSMutableOrderedSet alloc] init];
	
	[self.localizationStores enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id<DRLocalizationStore> localizationStore = obj;
		[supportedLanguages addObjectsFromArray:[[localizationStore supportedLanguages] array]];
	}];
	
	return [[NSOrderedSet alloc] initWithOrderedSet:supportedLanguages];
}

- (NSString *)systemPreferredLanguage
{
	return [[NSLocale preferredLanguages] objectAtIndex:0];
}

- (NSString *)currentLanguage
{
	if (!_currentLanguage) {
		if (self.persistCurrentLanguage) {
			_currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:DRLocalizationCurrentLanguageUserDefaultsKey];
			if (!_currentLanguage) {
				_currentLanguage = [self systemPreferredLanguage];
			}
		}
		else {
			_currentLanguage = [self systemPreferredLanguage];
		}
	}
	return _currentLanguage;
}

- (void)setCurrentLanguage:(NSString *)currentLanguage
{
	BOOL changed = ![currentLanguage isEqualToString:_currentLanguage];
	
	_currentLanguage = currentLanguage;
	
	if (changed) {
		[self forceLocalization];
		if (self.persistCurrentLanguage) {
			[[NSUserDefaults standardUserDefaults] setObject:_currentLanguage forKey:DRLocalizationCurrentLanguageUserDefaultsKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
	}
}

- (void)setPersistCurrentLanguage:(BOOL)persistCurrentLanguage
{
	_persistCurrentLanguage = persistCurrentLanguage;
	
	if (!_persistCurrentLanguage) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:DRLocalizationCurrentLanguageUserDefaultsKey];
	}
}

#pragma mark - Localize

- (void)forceLocalization
{
	[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:DRLocalizationLanguageDidChangeNotificationName object:nil]];
}

#pragma mark - Localized strings

- (NSString *)stringForKey:(NSString *)key
{
	return [self stringForKey:key forLanguage:self.currentLanguage];
}

- (NSString *)stringForKey:(NSString *)key forLanguage:(NSString *)language
{
	NSString __block *string = nil;
	
	[self.localizationStores enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id<DRLocalizationStore> localizationStore = obj;
		NSString *stringFromStore = [localizationStore stringForKey:key forLanguage:self.currentLanguage];
		if (stringFromStore) {
			string = [stringFromStore copy];
			*stop = YES;
		}
	}];
	
	if (!string) {
		NSLog(@"Localization not found for key: %@ and language: %@", key, language);
		string = [key copy];
	}
	
	return string;
}

@end
