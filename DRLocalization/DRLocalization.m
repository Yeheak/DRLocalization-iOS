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
		
		NSString *(^currentLanguage)() = ^() {
			if (!self.useSystemPreferredLanguages && self.fallbackLanguage) {
				return [self.fallbackLanguage copy];
			}
			return [[self systemPreferredLanguage] copy];
		};
		
		if (self.persistCurrentLanguage) {
			_currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:DRLocalizationCurrentLanguageUserDefaultsKey];
			if (!_currentLanguage) {
				_currentLanguage = currentLanguage();
			}
		}
		else {
			_currentLanguage = currentLanguage();
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
	return [self stringForKey:key forLanguage:language useFallbackLanguage:YES];
}

- (NSString *)stringForKey:(NSString *)key forLanguage:(NSString *)language useFallbackLanguage:(BOOL)fallback
{
	NSString __block *string = nil;
	
	// search for string in registered localization stores
	[self.localizationStores enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id<DRLocalizationStore> localizationStore = obj;
		NSString *stringFromStore = [localizationStore stringForKey:key forLanguage:language];
		if (stringFromStore) {
			string = [stringFromStore copy];
			*stop = YES;
		}
	}];
	
	// if string not found in registered localization stores
	if (!string) {
		
		if (fallback) {
			
			// if usign system preferred languages is enabled
			if (self.useSystemPreferredLanguages) {
				// search for string in user's preferred language
				[[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					NSString *preferredLanguage = obj;
					if (![preferredLanguage isEqualToString:language]) {
						string = [self stringForKey:key forLanguage:preferredLanguage useFallbackLanguage:NO];
						if (string) {
							*stop = YES;
						}
					}
				}];
			}
			
			// if string not found in user's preferred language and fallback language is set
			if (!string && self.fallbackLanguage) {
				// serach for string in fallback language
				if (self.fallbackLanguage && ![self.fallbackLanguage isEqualToString:language]) {
					string = [self stringForKey:key	forLanguage:self.fallbackLanguage useFallbackLanguage:NO];
				}
			}
		}
		
		if (!string && fallback) {
			#ifdef DEBUG
			NSLog((@"%s [Line %d]: " @"Localization not found for key: \"%@\" language: \"%@\""), __PRETTY_FUNCTION__, __LINE__,
				  key,
				  language);
			#endif
			string = [key copy];
		}
	}
	
	return string;
}

@end
