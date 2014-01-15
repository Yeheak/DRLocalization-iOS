//
//  DRLocalizationDeallocHelper.m
//  DRLocalization
//
//  Created by Dariusz Rybicki on 15.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRLocalizationDeallocHelper.h"

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
