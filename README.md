DRLocalization
==============

Simple Objective-C library created to make non-stadard localizations of iOS applications easier. The source is based on Baglan's MCLocalization library with some changes made to fulfil my project requirements. MCLocalization could be found here: https://raw.github.com/Baglan/MCLocalization

## Loading translations

DRLocalization can load translations directly from NSDictionary or from a file in JSON format, both should contains structure like in example bellow:  

  	{
	    "en": {
	        "greeting": "Hello, %name%!",
	        "message": "Tap on the buttons below to switch languages",
	    },
	    "pl": {
	        "greeting": "Witaj, %name%!",
	        "message": "Dotknij przycisku poniżej aby wybrać język",
	    }
	}

Collection of strings for each language is referenced by a canonicalized IETF BCP 47 language identifier (the same identifier used in NSLocale). Strings in a collection are further identified by keys.

## Installation

There is one class called DRLocalization, both files DRLocalization.h and DRLocalization.m should be included in the project you want to use it. You should only include a header file of that class in your code:

```objective-c
#include "DRLocalization.h"
```

You chould also install the library using CocoaPods. To do so, you will need to add this line to your Podfile:

	pod 'DRLocalization', :git => 'https://github.com/darrarski/DRLocalization.git'
	
and then run:

	pod install

## Usage

The localized string could be loaded from JSON file (should be included in you app bundle) or from NSDictionary that you could store in NSUserDefaults or for example download from remote server (when using AFNetworking, JSON returned by the server can be converted to a dictionary on the fly):

```objective-c
NSString * path = [[NSBundle mainBundle] pathForResource:@"translations.json" ofType:nil];
[[DRLocalization sharedInstance] loadFromJSONFile:path defaultLanguage:@"en"];
```

```objective-c
[[DRLocalization sharedInstance] loadFromDictionary:translationsDictionary defaultLanguage:@"en"];
```

After translations are loaded, you could retrieve localized string by using one of DRLocalization instance methods:

```objective-c
- (NSString *)stringForKey:(NSString *)key;
```
will return a string in current language

```objective-c
- (NSString *)stringForKey:(NSString *)key language:(NSString *)language;
```
will return a string in given language (that should be a canonical IETF BCP 47 language identifier)

```objective-c
- (NSString *)stringForKey:(NSString *)key withPlaceholders:(NSDictionary *)placeholders;
- (NSString *)stringForKey:(NSString *)key withPlaceholders:(NSDictionary *)placeholders language:(NSString *)language;
```
will return a string with placeholders from given dictionary keys replaced with strings from the dictionary values

There is also a macro for retrieving localized string in current language:

```objective-c
DRLOC(@"string_key");
```

will call

```objective-c
[[DRLocalization sharedInstance] stringForKey:@"string_key"];
```

You could also:

- get an array with canonical identifiers of loaded languages:

```objective-c
NSArray *supportedLanguages = [[DRLocalization sharedInstance] supportedLanguages];
```

- set current languge:

```objective-c
[[DRLocalization sharedInstance] setLanguage:@"en"];
```

if given language is not found, the library will try to load system or default language

- set a placeholder text returned by library if there is translation missing for given key:

```objective-c
[[DRLocalization sharedInstance] setNotFoundPlaceholder:@"translation missing: %key%"];
```

## License

Code in this project is available under the MIT license.
