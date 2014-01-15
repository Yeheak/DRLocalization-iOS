//
//  DRLocalizationDeallocHelper.h
//  DRLocalization
//
//  Created by Dariusz Rybicki on 15.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRLocalizationDeallocHelper : NSObject

@property (nonatomic, copy) void(^deallocBlock)();

- (id)initWithBlock:(void(^)())block;

@end
