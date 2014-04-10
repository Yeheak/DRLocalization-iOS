//
//  NSObject+DRLocalization.h
//  DRLocalization
//
//  Created by Dariusz Rybicki on 09.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DRPostLocalizationBlock)(id localizedObject);

@interface NSObject (DRLocalization)

/**
 *  Block that will be called after localization (optional)
 */
@property (nonatomic, copy) DRPostLocalizationBlock DRPostLocalizationBlock;

/**
 *  Localization key used by DRLocalization library
 */
@property (nonatomic, readwrite) NSString *DRLocalizationKey;

/**
 *  Localization keyPath used by DRLocalization library
 */
@property (nonatomic, readwrite) NSString *DRLocalizationKeyPath;

/**
 *  Force object localization
 */
- (void)DRLocalize;

@end
