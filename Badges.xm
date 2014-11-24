/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/

static NSDictionary *getBadgeSettings()
{
	NSDictionary *wbPlist = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Library/Preferences/com.saurik.WinterBoard.plist"]];
	NSArray *themes = wbPlist[@"Themes"];
	
	for (NSDictionary *theme in themes)
	{
		if ([theme[@"Active"] boolValue])
		{
			NSString *themeName = theme[@"Name"];
			NSString *path = [NSString stringWithFormat:@"/Library/Themes/%@.theme/Info.plist",themeName];
			NSDictionary *themeDict = [NSDictionary dictionaryWithContentsOfFile:path];

			if (themeDict[@"BadgeSettings"] != nil)
			{
				return themeDict[@"BadgeSettings"];
			}
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
	NSString *badgeFont = @"HelveticaNeue-Light";
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