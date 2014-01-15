//
//  UIButton+DRLocalization.m
//  DRLocalization
//
//  Created by Dariusz Rybicki on 15.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "UIButton+DRLocalization.h"
#import "DRLocalization.h"

@implementation UIButton (DRLocalization)

- (void)DRLocalize
{
	NSString *key = self.DRLocalizationKey;
	NSString *keyPath = self.DRLocalizationKeyPath;
	
	if (key && !keyPath) {
		[self setTitle:[[DRLocalization sharedInstance] stringForKey:key] forState:UIControlStateNormal];
	}
	else {
		[super DRLocalize];
	}
	
	[self sizeToFit];
}

@end
