@interface ThemeLibSettingsManager : NSObject {
	NSArray *_themeSettings;
}
+ (id)sharedManager;
- (NSArray *)themeSettings;
@end