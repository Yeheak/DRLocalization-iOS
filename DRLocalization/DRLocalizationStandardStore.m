//
//  DRLocalizationStandardStore.m
//  DRLocalization
//
//  Created by Dariusz Rybicki on 15.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRLocalizationStandardStore.h"

@implementation DRLocalizationStandardStore

- (NSOrderedSet *)supportedLanguages
{
	return [[NSOrderedSet alloc] initWithObject:[[NSLocale preferredLanguages] objectAtIndex:0]];
}

- (NSString *)stringForKey:(NSString *)key forLanguage:(NSString *)language
{
	if ([[self.supportedLanguages firstObject] isEqualToString:language]) {
		return NSLocalizedString(key, key);
	}
	else {
		return nil;
	}
}

@end
