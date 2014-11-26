#import "themelibuikit/ThemeLibSettingsManager.h"

static NSDictionary *getBadgeSettings()
{
	NSArray *themes = [[%c(ThemeLibSettingsManager) sharedManager] themeSettings];
	
	for (NSDictionary *theme in themes)
	{
		NSString *themeName = theme[@"Name"];
		NSString *path = [NSString stringWithFormat:@"/Library/Themes/%@.theme/Info.plist",themeName];
		NSDictionary *themeDict = [NSDictionary dictionaryWithContentsOfFile:path];

		if (themeDict[@"ThemeLib-BadgeSettings"] != nil)
		{
			return themeDict[@"ThemeLib-BadgeSettings"];
		}
	}
	return nil;
}

@interface SBIconAccessoryImage : NSObject
- (id)initWithImage:(UIImage *)image;
@end

%hook SBIconBadgeView

+ (SBIconAccessoryImage *)_checkoutBackgroundImage {
	if ([UIImage imageNamed:@"SBBadgeBG.png"])
    	return [[%c(SBIconAccessoryImage) alloc] initWithImage:[UIImage imageNamed:@"SBBadgeBG.png"]];
    else
    	return %orig;
}

+ (SBIconAccessoryImage *)_checkoutImageForText:(NSString *)text highlighted:(BOOL)highlighted {
	NSDictionary *badgeSettings = getBadgeSettings();
	NSString *badgeFont = @"HelveticaNeue";
	CGFloat badgeFontSize = 16.0f;
	CGFloat badgeHeightChange = 0.0f; //0.0f for classic
	CGFloat badgeWidthChange = 0.0f; //2.0f for classic
	CGFloat badgeXoffset = 0.0f; //2.0f for classic
	CGFloat badgeYoffset = 0.0f; //-2.0f for classic
	if ([badgeSettings objectForKey:@"FontName"])
		badgeFont = [badgeSettings objectForKey:@"FontName"];
	if ([badgeSettings objectForKey:@"FontSize"])
		badgeFontSize = [[badgeSettings objectForKey:@"FontSize"] floatValue];
	if ([badgeSettings objectForKey:@"HeightChange"])
		badgeHeightChange = [[badgeSettings objectForKey:@"HeightChange"] floatValue];
	if ([badgeSettings objectForKey:@"WidthChange"])
		badgeWidthChange = [[badgeSettings objectForKey:@"WidthChange"] floatValue];
	if ([badgeSettings objectForKey:@"TextXoffset"])
		badgeXoffset = [[badgeSettings objectForKey:@"TextXoffset"] floatValue];
	if ([badgeSettings objectForKey:@"TextYoffset"])
		badgeYoffset = [[badgeSettings objectForKey:@"TextYoffset"] floatValue];

	UIFont *font = [UIFont fontWithName:badgeFont size:badgeFontSize];
	CGSize size = [text sizeWithFont:font];
	if (size.height != 0)
		size.height += badgeHeightChange;
	if (size.width != 0)
		size.width += badgeWidthChange;
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	[[UIColor whiteColor] set];
	[text drawAtPoint:CGPointMake(badgeXoffset,badgeYoffset) withFont:font];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return [[%c(SBIconAccessoryImage) alloc] initWithImage:image];
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end