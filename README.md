DRLocalization
==============

Simple Objective-C library created to make non-standard localizations of iOS applications easier. It allows to load translations from external sources, as well as using standard iOS localized strings. Localization setup for objects of any type can be setup and proceeded programatically or using interface builder. If you are looking for specific version of the library, checkout those branches:

- For development version - [master branch](../../tree/master)
- For v0.2.x - [branch 0.2](../../tree/0.2)
- For v0.1.x - [branch 0.1](../../tree/0.1)

## Installation

You can install the library using CocoaPods. To do so, you will need to add one of the following lines to your Podfile:

For most recent or development version:

	pod "DRLocalization", :git => "https://github.com/darrarski/DRLocalization-iOS"

For specific version:

	pod "DRLocalization", :git => "https://github.com/darrarski/DRLocalization-iOS", :branch => "VERSION_BRANCH"

Where `VERSION_BRANCH` you should put the branch name for given version (ex. "0.1", "0.2"). It is recommended to set version branch explicity, as backward compatibility between those branches is not warranted. Master branch always contains the most recent version.

## Usage

Public methods of the library are documented in-code. For detailed examples check out attached demo project.

## License

Code in this project is available under the MIT license.

## Credits

The library is using concepts from:

- [MCLocalization](https://raw.github.com/Baglan/MCLocalization)
- [DPLocalization](https://github.com/nullic/DPLocalizationManager)
