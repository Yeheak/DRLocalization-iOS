//
//  NSObject+DRLocalization.m
//  DRLocalization
//
//  Created by Dariusz Rybicki on 09.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "NSObject+DRLocalization.h"
#import <objc/runtime.h>
#import "DRLocalization.h"
#import "DRLocalizationDeallocHelper.h"

static NSString *DRLocalizationKeyKey = @"DRLocalizationKeyKey";
static NSString *DRLocalizationKeyPathKey = @"DRLocalizationKeyPathKey";
static NSString *DRLocalizationDeallocHelperKey = @"DRLocalizationDeallocHelperKey";
static NSString *DRPostLocalizationBlockKey = @"DRPostLocalizationBlockKey";

@implementation NSObject (DRLocalization)

#pragma mark Localization setup

- (void)setupDRLocalization
{
	if (![self DRLocalizationDeallocHelper]) {
		NSObject * __weak selfWeak = self;
		
		id observer = [[NSNotificationCenter defaultCenter] addObserverForName:DRLocalizationLanguageDidChangeNotificationName
																		object:nil
																		 queue:[NSOperationQueue mainQueue]
																	usingBlock:^(NSNotification *note) {
																		__strong NSObject *selfStrong = selfWeak;
																		[selfStrong DRLocalize];
																	}];
		
		[self setDRLocalizationDeallocHelper:[[DRLocalizationDeallocHelper alloc] initWithBlock:^{
			[[NSNotificationCenter defaultCenter] removeObserver:observer];
		}]];
		
		[self DRLocalize];
	}
}

#pragma mark Localization

- (void)DRLocalize
{
	NSString *key = self.DRLocalizationKey;
	NSString *keyPath = self.DRLocalizationKeyPath;
	
	if (key && keyPath) {
		[self setValue:[[DRLocalization sharedInstance] stringForKey:key] forKey:keyPath];
	}
	
	if (self.DRPostLocalizationBlock) {
		self.DRPostLocalizationBlock(self);
	}
}

#pragma mark Getters and setters

- (void)setDRLocalizationDeallocHelper:(DRLocalizationDeallocHelper *)deallocHelper
{
	objc_setAssociatedObject(self, (__bridge void *)(DRLocalizationDeallocHelperKey), deallocHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DRLocalizationDeallocHelper *)DRLocalizationDeallocHelper
{
	return objc_getAssociatedObject(self, (__bridge const void *)(DRLocalizationDeallocHelperKey));
}

- (void)setDRLocalizationKey:(NSString *)key
{
	objc_setAssociatedObject(self, (__bridge void *)(DRLocalizationKeyKey), [key copy], OBJC_ASSOCIATION_COPY);
	[self setupDRLocalization];
}

- (NSString *)DRLocalizationKey
{
	return objc_getAssociatedObject(self, (__bridge const void *)(DRLocalizationKeyKey));
}

- (void)setDRLocalizationKeyPath:(NSString *)keyPath
{
	objc_setAssociatedObject(self, (__bridge void *)(DRLocalizationKeyPathKey), [keyPath copy], OBJC_ASSOCIATION_COPY);
}

- (NSString *)DRLocalizationKeyPath
{
	return objc_getAssociatedObject(self, (__bridge const void *)(DRLocalizationKeyPathKey));
}

- (DRPostLocalizationBlock)DRPostLocalizationBlock
{
	return objc_getAssociatedObject(self, (__bridge const void *)(DRPostLocalizationBlockKey));
}

- (void)setDRPostLocalizationBlock:(DRPostLocalizationBlock)DRPostLocalizationBlock
{
	objc_setAssociatedObject(self, (__bridge void *)DRPostLocalizationBlockKey, [DRPostLocalizationBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
