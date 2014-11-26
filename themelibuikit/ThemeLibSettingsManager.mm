#import "ThemeLibSettingsManager.h"
static ThemeLibSettingsManager *sharedObject = nil;

@implementation ThemeLibSettingsManager

+ (id)sharedManager {
    if (!sharedObject)
        sharedObject = [[self alloc] init];
    return sharedObject;
}

- (NSArray *)themeSettings {
	if (!_themeSettings){
		NSDictionary *wbPlist = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.saurik.WinterBoard.plist"];
		NSArray *themes = wbPlist[@"Themes"];
		NSMutableArray *themeSettings = [[NSMutableArray alloc] init];
		for (NSDictionary *theme in themes){
			if ([theme[@"Active"] boolValue]){
				[themeSettings addObject:theme];
			}
		}
		_themeSettings = themeSettings;
	}
	return _themeSettings;
}
@end