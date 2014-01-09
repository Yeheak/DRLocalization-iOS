//
//  NSObject+DRLocalization.m
//  DRLocalizationDemo
//
//  Created by Dariusz Rybicki on 09.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "NSObject+DRLocalization.h"
#import <objc/runtime.h>
#import "DRLocalization.h"

static NSString *DRLocalizationKeyKey = @"DRLocalizationKeyKey";
static NSString *DRLocalizationKeyPathKey = @"DRLocalizationKeyPathKey";
static NSString *DRLocalizationDeallocHelperKey = @"DRLocalizationDeallocHelperKey";

#pragma mark - DRLocalizationDeallocHelper

@interface DRLocalizationDeallocHelper : NSObject

@property (nonatomic, copy) void(^deallocBlock)();

@end

@implementation DRLocalizationDeallocHelper

- (id)initWithBlock:(void(^)())block
{
	if (self = [super init]) {
		self.deallocBlock = block;
	}
	return self;
}

- (void)dealloc
{
	if (self.deallocBlock) {
		self.deallocBlock();
	}
}

@end

#pragma mark - NSObject+DRLocalization

@implementation NSObject (DRLocalization)

#pragma mark Localization setup

- (void)setupDRLocalization
{
	DRLocalizationDeallocHelper *deallocHelper = objc_getAssociatedObject(self, (__bridge const void *)(DRLocalizationDeallocHelperKey));
	
	if (!deallocHelper) {
		NSObject * __weak selfWeak = self;
		
		id observer = [[NSNotificationCenter defaultCenter] addObserverForName:DRLocalizationLanguageDidChangeNotification
																		object:nil
																		 queue:[NSOperationQueue mainQueue]
																	usingBlock:^(NSNotification *note) {
																		__strong NSObject *selfStrong = selfWeak;
																		[selfStrong DRLocalize];
																	}];
		
		deallocHelper = [[DRLocalizationDeallocHelper alloc] initWithBlock:^{
			[[NSNotificationCenter defaultCenter] removeObserver:observer];
		}];
		
		objc_setAssociatedObject(self, (__bridge void *)(DRLocalizationDeallocHelperKey), deallocHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		
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
}

#pragma mark Getters and setters

- (void)setDRLocalizationKey:(NSString *)key
{
	objc_setAssociatedObject(self, (__bridge void *)(DRLocalizationKeyKey), key, OBJC_ASSOCIATION_COPY);
	
	[self setupDRLocalization];
}

- (NSString *)DRLocalizationKey
{
	return objc_getAssociatedObject(self, (__bridge const void *)(DRLocalizationKeyKey));
}

- (void)setDRLocalizationKeyPath:(NSString *)keyPath
{
	objc_setAssociatedObject(self, (__bridge void *)(DRLocalizationKeyPathKey), keyPath, OBJC_ASSOCIATION_COPY);
	
	[self setupDRLocalization];
}

- (NSString *)DRLocalizationKeyPath
{
	return objc_getAssociatedObject(self, (__bridge const void *)(DRLocalizationKeyPathKey));
}

@end
