//
//  DRLocalization.m
//  Surveyor-Horti
//
//  Created by Dariusz Rybicki on 24.06.2013.
//  Copyright (c) 2013 Darrarski. All rights reserved.
//

#import "DRLocalization.h"

#define DRLOCALIZATION_PREFERRED_LOCALE_KEY @"DRLOCALIZATION_PREFERRED_LOCALE_KEY"

@implementation DRLocalization
{
	NSString * _language;
	NSDictionary * _strings;
    NSString * _defaultLanguage;
}

- (id)init
{
	if((self=[super init]))
	{
		_notFoundPlaceholder = @"translation missing: %key%";
	}
	return self;
}

#pragma mark - Singleton

+ (DRLocalization *)sharedInstance
{
	__strong static id _sharedObject = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedObject = [[self alloc] init];
	});
	return _sharedObject;
}

#pragma mark - Loaders

- (void)loadFromJSONFile:(NSString *)fileName defaultLanguage:(NSString *)defaultLanguage
{
	_strings = nil;
	NSData * JSONData = [NSData dataWithContentsOfFile:fileName];
	_strings = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:nil];
	_defaultLanguage = defaultLanguage;
}

- (void)loadFromDictionary:(NSDictionary *)dictionary defaultLanguage:(NSString *)defaultLanguage
{
	_strings = dictionary;
	_defaultLanguage = defaultLanguage;
}

#pragma mark - Language config

- (NSArray *)supportedLanguages
{
	NSArray *keys = [_strings allKeys];
	NSMutableArray *supportedLanguages = [[NSMutableArray alloc] init];
	
	for(id lang in keys)
	{
		if([[_strings objectForKey:lang] isKindOfClass:[NSDictionary class]])
		{
			[supportedLanguages addObject:lang];
		}
	}
	
    return [NSArray arrayWithArray:supportedLanguages];
}

- (NSString *)sanitizeLanguage:(NSString *)language
{
    // Is language supported?
    if ([self.supportedLanguages indexOfObject:language] == NSNotFound)
	{
		language = nil;
    }
    
    // Try to figure out language from locale
	if (!language)
	{
		NSArray *preferredLanguages = [NSLocale preferredLanguages];
		language = [preferredLanguages firstObjectCommonWithArray:self.supportedLanguages];
	}
    
    // In the worst case, return default setting
    if (language == nil)
	{
        language = _defaultLanguage;
    }
    
    return language;
}

- (NSString *)language
{
    if (!_language)
	{
        NSString *preferredLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:DRLOCALIZATION_PREFERRED_LOCALE_KEY];
        preferredLanguage = [self sanitizeLanguage:preferredLanguage];
        self.language = [preferredLanguage copy];
    }
    return _language;
}

- (void)setLanguage:(NSString *)language
{
	language = [self sanitizeLanguage:language];
	
	// Skip is the new setting is the same as the old one
    if (![language isEqual:_language])
	{
        // Get rid of the current setting
        _language = nil;
        
        // Check if new setting is supported by localization
        if ([self.supportedLanguages indexOfObject:language] != NSNotFound)
		{
			_language = [language copy];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:DRLocalizationLanguageDidChangeNotification object:nil]];
			
			[[NSUserDefaults standardUserDefaults] setObject:_language forKey:DRLOCALIZATION_PREFERRED_LOCALE_KEY];
			[[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#pragma mark - Strings

- (NSString *)stringForKey:(NSString *)key
{
    return [self stringForKey:key language:self.language];
}

- (NSString *)stringForKey:(NSString *)key language:(NSString *)language
{
    NSDictionary * langugeStrings = _strings[language];
    NSString * string = langugeStrings[key];
    if (!string)
	{
        NSLog(@"DRLocalization: no string for key %@ in language %@", key, language);
		string = [_notFoundPlaceholder stringByReplacingOccurrencesOfString:@"%key%" withString:key];
    }
    return string;
}

- (NSString *)stringForKey:(NSString *)key withPlaceholders:(NSDictionary *)placeholders
{
	return [self stringForKey:key withPlaceholders:placeholders language:self.language];
}

- (NSString *)stringForKey:(NSString *)key withPlaceholders:(NSDictionary *)placeholders language:(NSString *)language
{
	NSString *string = [self stringForKey:key language:language];
	NSString *result = string;
    
    NSError *e;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"%([a-zA-Z0-9]+?)%"
                                                                           options:0
                                                                             error:&e];
    
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    
    if (!e && matches)
	{
        for (NSTextCheckingResult *match in matches)
		{
            NSRange matchRange = [match range];
            NSString *placeholderKey = [string substringWithRange:matchRange];
            
            NSString *placeholderValue = (NSString *) [placeholders objectForKey:placeholderKey];
            
            if (!placeholderValue)
			{
                NSLog(@"DRLocalization: no value for placeholder %@ for key %@ in language %@", placeholderKey, key, self.language);
            }
            
            result = [result stringByReplacingOccurrencesOfString:placeholderKey withString:placeholderValue];
        }
    }
    
    return result;
    
}

@end
