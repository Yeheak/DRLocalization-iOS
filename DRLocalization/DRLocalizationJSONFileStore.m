//
//  DRLocalizationJSONFileStore.m
//  DRLocalization
//
//  Created by Dariusz Rybicki on 15.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRLocalizationJSONFileStore.h"

@implementation DRLocalizationJSONFileStore
{
	NSOrderedSet *_supportedLanguages;
}

@synthesize supportedLanguages = _supportedLanguages;

- (id)initWithFilePath:(NSString *)filePath andSupportedLanguages:(NSArray *)languages
{
	if (self = [super init]) {
		_filePath = filePath;
		_supportedLanguages = [[NSOrderedSet alloc] initWithArray:languages];
	}
	return self;
}

- (NSString *)stringForKey:(NSString *)key forLanguage:(NSString *)language
{
	NSString *string = nil;
	
	if ([[self.supportedLanguages firstObject] isEqualToString:language]) {
		NSData *JSONData = [NSData dataWithContentsOfFile:self.filePath];
		if (JSONData) {
			NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:nil];
			if ([dictionary isKindOfClass:[NSDictionary class]]) {
				string = dictionary[key];
			}
		}
	}
	
	return string;
}

@end
