//
//  DRLocalizationJSONFileStore.h
//  DRLocalization
//
//  Created by Dariusz Rybicki on 15.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DRLocalizationStore.h"

@interface DRLocalizationJSONFileStore : NSObject <DRLocalizationStore>

/**
 *  File path
 */
@property (nonatomic, strong) NSString *filePath;

/**
 *  Initialize store with file at path and supported languages
 *
 *  @param filePath  Localization file path
 *  @param languages Supported language codes array
 *
 *  @return DRLocalizationJSONFileStore object
 */
- (id)initWithFilePath:(NSString *)filePath andSupportedLanguages:(NSArray *)languages;

@end
