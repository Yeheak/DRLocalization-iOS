//
//  UILabel+DRLocalization.m
//  DRLocalization
//
//  Created by Dariusz Rybicki on 09.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "UILabel+DRLocalization.h"
#import "DRLocalization.h"

@implementation UILabel (DRLocalization)

- (void)DRLocalize
{
	NSString *key = self.DRLocalizationKey;
	NSString *keyPath = self.DRLocalizationKeyPath;
	
	if (key && !keyPath) {
		self.text = [[DRLocalization sharedInstance] stringForKey:key];
	}
	else {
		[super DRLocalize];
	}
}

@end
