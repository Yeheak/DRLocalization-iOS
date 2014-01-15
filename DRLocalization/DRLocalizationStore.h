//
//  DRLocalizationStore.h
//  DRLocalization
//
//  Created by Dariusz Rybicki on 15.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DRLocalizationStore <NSObject>

/**
 *  Ordered set of language codes (strings) supported by the store
 */
@property (nonatomic, readonly) NSOrderedSet *supportedLanguages;

/**
 *  Returns localized string with given key for given language
 *
 *  @param key      Localization key
 *  @param language Language code
 *
 *  @return Localized string
 */
- (NSString *)stringForKey:(NSString *)key forLanguage:(NSString *)language;

@end
