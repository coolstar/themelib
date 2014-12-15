#import "ThemeLibSettingsManager.h"
#import <objc/runtime.h>

@interface _UIAssetManager : NSObject
	@property (readonly) NSBundle *bundle;
	@property (readonly) NSString *carFileName;
@end

@interface UIImage (Private)
	+ (UIImage *)kitImageNamed:(NSString *)name;
@end

struct SizeClassPair {
	NSInteger width;
	NSInteger height;
};

static char *UIKitCarBundle;

static BOOL isAssetManagerUIKit(_UIAssetManager *manager){
	NSBundle *bundle = nil;
	if (kCFCoreFoundationVersionNumber <= 847.27)
		bundle = objc_getAssociatedObject(manager, &UIKitCarBundle);
	else
		bundle = manager.bundle;
	if ([manager.carFileName isEqualToString:@"UIKit_Artwork"] && [bundle.bundlePath isEqualToString:@"/System/Library/Frameworks/UIKit.framework/Artwork.bundle"]){
		return YES;
	}
	return NO;
}

static UIImage *getUIKitImageForName(NSString *name){
	NSArray *themes = [[ThemeLibSettingsManager sharedManager] themeSettings];
	
	for (NSDictionary *theme in themes)
	{
		NSString *themeName = theme[@"Name"];
		NSString *path = [NSString stringWithFormat:@"/Library/Themes/%@.theme/UIImages/%@",themeName,name];
		if ([UIImage imageWithContentsOfFile:path])
			return [UIImage imageWithContentsOfFile:path];
	}
	return nil;
}

%group iOS8
%hook _UIAssetManager
- (id)imageNamed:(id)name scale:(float)arg2 idiom:(int)arg3 subtype:(unsigned int)arg4 cachingOptions:(unsigned int)arg5 sizeClassPair:(SizeClassPair)arg6 attachCatalogImage:(BOOL)arg7 {
	if (isAssetManagerUIKit(self)){
		UIImage *ret = getUIKitImageForName(name);
		if (ret != nil){
			return ret;
		} else {
			return %orig;
		}
	}
	return %orig;
}

%end
%end

%group iOS7
%hook _UIAssetManager
- (id)initWithName:(NSString *)name inBundle:(NSBundle *)bundle idiom:(int)idiom {
	self = %orig;
	if (self)
		objc_setAssociatedObject(self, &UIKitCarBundle, bundle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	return self;
}

- (id)imageNamed:(id)name scale:(float)arg2 idiom:(int)arg3 subtype:(unsigned int)arg4 cachingOptions:(unsigned int)arg5 {
	if (isAssetManagerUIKit(self)){
		UIImage *ret = getUIKitImageForName(name);
		if (ret != nil){
			return ret;
		} else {
			return %orig;
		}
	}
	return %orig;
}
%end
%end

%ctor {
	if (kCFCoreFoundationVersionNumber >= 847.20){
		if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"org.coolstar.anemone"]){
			if (kCFCoreFoundationVersionNumber <= 847.27){
				%init(iOS7);
			} else {
				%init(iOS8);
			}
		}
	}
}