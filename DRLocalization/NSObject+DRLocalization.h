//
//  NSObject+DRLocalization.h
//  DRLocalizationDemo
//
//  Created by Dariusz Rybicki on 09.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DRLocalization)

@property (nonatomic, strong) NSString *DRLocalizationKey;
@property (nonatomic, strong) NSString *DRLocalizationKeyPath;

- (void)DRLocalize;

@end
