//
//  DRViewController.m
//  DRLocalizationExample
//
//  Created by Dariusz Rybicki on 08.01.2014.
//  Copyright (c) 2014 Darrarski. All rights reserved.
//

#import "DRViewController.h"
#import "DRLocalization.h"

@interface DRViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation DRViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder]) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(localizeSegmentedControl)
													 name:DRLocalizationLanguageDidChangeNotificationName
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setupSegmentedControl];
	[self localizeSegmentedControl];
}

#pragma mark - Language switcher

- (void)setupSegmentedControl
{
	// propagate segmented control with supported languages
	NSOrderedSet *supportedLanguages = [[DRLocalization sharedInstance] supportedLanguages];
	[self.segmentedControl removeAllSegments];
	[supportedLanguages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *langCode = (NSString *)obj;
		[self.segmentedControl insertSegmentWithTitle:langCode atIndex:idx animated:NO];
		if ([[[DRLocalization sharedInstance] currentLanguage] isEqualToString:langCode]) {
			self.segmentedControl.selectedSegmentIndex = idx;
		}
	}];
	
	// setup segmented control value changed action
	[self.segmentedControl addTarget:self
							  action:@selector(segmentedControlValueChanged)
					forControlEvents:UIControlEventValueChanged];
}

- (void)localizeSegmentedControl
{
	NSOrderedSet *supportedLanguages = [[DRLocalization sharedInstance] supportedLanguages];
	[supportedLanguages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (self.segmentedControl.numberOfSegments > idx) {
			NSString *langCode = (NSString *)obj;
			NSString *localizedString = [[DRLocalization sharedInstance] stringForKey:[NSString stringWithFormat:@"language_%@", langCode]];
			[self.segmentedControl setTitle:localizedString forSegmentAtIndex:idx];
		}
	}];
}

- (void)segmentedControlValueChanged
{
	// get index of selected language
	NSInteger langIdx = self.segmentedControl.selectedSegmentIndex;
	
	// get langauge code for selected index
	NSString *langCode = [[[DRLocalization sharedInstance] supportedLanguages] objectAtIndex:langIdx];
	
	// change language
	[[DRLocalization sharedInstance] setCurrentLanguage:langCode];
}

@end
