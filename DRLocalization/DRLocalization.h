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
 *  Set NO to disable current language persitance in NSUserDefauls (default value is YES)
 */
@property (nonatomic, readwrite) BOOL persistCurrentLanguage;

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
 *  Returns localized string with given key for given language
 *
 *  @param key      Localization key
 *  @param language Language code
 *
 *  @return Localized string
 */
- (NSString *)stringForKey:(NSString *)key forLanguage:(NSString *)language;

/**
 *  Force localization immediately
 */
- (void)forceLocalization;

@end
