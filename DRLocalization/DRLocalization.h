//
//  DRLocalization.h
//  Surveyor-Horti
//
//  Created by Dariusz Rybicki on 24.06.2013.
//  Copyright (c) 2013 EL Passion. All rights reserved.
//
//  Based on https://github.com/Baglan/MCLocalization
//

#import <Foundation/Foundation.h>

#define DRLocalizationLanguageDidChangeNotification @"DRLocalizationLanguageDidChangeNotification"

#define DRLOC(key) [[DRLocalization sharedInstance] stringForKey:key]

@interface DRLocalization : NSObject

@property (nonatomic, copy) NSString * language;
@property (nonatomic, readonly) NSArray * supportedLanguages;
@property (nonatomic, readonly) NSString * systemLanguage;
@property (nonatomic, strong) NSString *notFoundPlaceholder;

+ (DRLocalization *)sharedInstance;

- (void)loadFromJSONFile:(NSString *)fileName defaultLanguage:(NSString *)defaultLanguage;
- (void)loadFromDictionary:(NSDictionary *)dictionary defaultLanguage:(NSString *)defaultLanguage;

- (NSString *)stringForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key language:(NSString *)language;
- (NSString *)stringForKey:(NSString *)key withPlaceholders:(NSDictionary *)placeholders;
- (NSString *)stringForKey:(NSString *)key withPlaceholders:(NSDictionary *)placeholders language:(NSString *)language;

@end