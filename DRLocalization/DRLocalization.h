//
//  DRLocalization.h
//  DRLocalization
//
//  Created by Dariusz Rybicki on 24.06.2013.
//  Copyright (c) 2013 Darrarski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+DRLocalization.h"
#import "DRLocalizationStore.h"
#import "DRLocalizationStandardStore.h"
#import "DRLocalizationJSONFileStore.h"

/**
 *  When language is changed local notification with this name is posted using default notification center.
 *  You can listen to this notifications and do some custom localization if needed. 
 */
static NSString *DRLocalizationLanguageDidChangeNotificationName = @"DRLocalizationLanguageDidChangeNotification";

@interface DRLocalization : NSObject

/**
 *  Array of registered localization stores
 */
@property (nonatomic, strong) NSArray *localizationStores;

/**
 *  Ordered set of supported languages (retrieved from registered stores)
 */
@property (nonatomic, readonly) NSOrderedSet *supportedLanguages;

/**
 *  Current language code
 */
@property (nonatomic, strong) NSString *currentLanguage;

/**
 *  Set NO to disable current language persitance in NSUserDefauls. 
 *  Default value is YES.
 */
@property (nonatomic, readwrite) BOOL persistCurrentLanguage;

/**
 *  Set YES to enable fallback to system preferred language. 
 *  Used when a string in given language is not available. 
 *  Default value is NO.
 */
@property (nonatomic, readwrite) BOOL useSystemPreferredLanguages;

/**
 *  Fallback language code.
 *  Used when a string in given language is not available in registered stores 
 *  as well as system prefered languages (if useSystemPreferredLanguages is set to YES).
 */
@property (nonatomic, strong) NSString *fallbackLanguage;

/**
 *  Returns shared instance
 *
 *  @return Shared DRLocalization object
 */
+ (instancetype)sharedInstance;

/**
 *  Add localization store
 *
 *  @param localizationStore Object that implements DRLocalizationStore protocol
 */
- (void)addLocalizationStore:(id<DRLocalizationStore>)localizationStore;

/**
 *  Returns localized string with given key
 *
 *  @param key Localization key
 *
 *  @return Localized string
 */
- (NSString *)stringForKey:(NSString *)key;

/**
 *  Returns localized string with given key for given language using fallback to 
 *  preferred languages (if enabled) or fallback language (if set).
 *
 *  @param key      Localization key
 *  @param language Language code
 *
 *  @return Localized string or localization key if string not found
 */
- (NSString *)stringForKey:(NSString *)key forLanguage:(NSString *)language;

/**
 *  Returns localized string with given key for given language
 *
 *  @param key      Localization key
 *  @param language Language code
 *  @param fallback Use fallback to preferred languages (if enabled) or fallback language (if set)
 *
 *  @return Localized string or localization key if string not found
 */
- (NSString *)stringForKey:(NSString *)key forLanguage:(NSString *)language useFallbackLanguage:(BOOL)fallback;

/**
 *  Force localization immediately
 */
- (void)forceLocalization;

@end
