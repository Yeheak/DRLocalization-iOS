//
//  UIImageView+DRLocalization.m
//  DRLocalization
//
//  Created by Dariusz Rybicki on 16.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "UIImageView+DRLocalization.h"
#import "DRLocalization.h"

@implementation UIImageView (DRLocalization)

- (void)DRLocalize
{
	NSString *key = self.DRLocalizationKey;
	NSString *keyPath = self.DRLocalizationKeyPath;
	
	if (key && !keyPath) {
		NSString *imageName = [[DRLocalization sharedInstance] stringForKey:key];
		UIImage *image = [UIImage imageNamed:imageName];
		[self setImage:image];
	}
	else {
		[super DRLocalize];
	}
}

@end
