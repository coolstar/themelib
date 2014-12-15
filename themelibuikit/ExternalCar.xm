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

static char *ExternalCarBundle;

static BOOL isAssetManagerNotUIKit(_UIAssetManager *manager){
	NSBundle *bundle = nil;
	if (kCFCoreFoundationVersionNumber <= 847.27)
		bundle = objc_getAssociatedObject(manager, &ExternalCarBundle);
	else
		bundle = manager.bundle;
	if ([manager.carFileName isEqualToString:@"UIKit_Artwork"] && [bundle.bundlePath isEqualToString:@"/System/Library/Frameworks/UIKit.framework/Artwork.bundle"]){
		return NO;
	}
	return YES;
}

static UIImage *getImageForName(NSString *name, NSBundle *bundle){
	NSArray *themes = [[ThemeLibSettingsManager sharedManager] themeSettings];
	
	for (NSDictionary *theme in themes)
	{
		NSString *themeName = theme[@"Name"];
		NSString *path = [NSString stringWithFormat:@"/Library/Themes/%@.theme/Bundles/%@/%@",themeName,bundle.bundleIdentifier,name];
		if ([UIImage imageWithContentsOfFile:path])
			return [UIImage imageWithContentsOfFile:path];
	}
	return nil;
}

%group iOS8
%hook _UIAssetManager
- (id)imageNamed:(id)name scale:(float)arg2 idiom:(int)arg3 subtype:(unsigned int)arg4 cachingOptions:(unsigned int)arg5 sizeClassPair:(SizeClassPair)arg6 attachCatalogImage:(BOOL)arg7 {
	if (isAssetManagerNotUIKit(self)){
		UIImage *ret = getImageForName(name, self.bundle);
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
		objc_setAssociatedObject(self, &ExternalCarBundle, bundle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	return self;
}

- (id)imageNamed:(id)name scale:(float)arg2 idiom:(int)arg3 subtype:(unsigned int)arg4 cachingOptions:(unsigned int)arg5 {
	if (isAssetManagerNotUIKit(self)){
		NSBundle *bundle = objc_getAssociatedObject(self, &ExternalCarBundle);
		UIImage *ret = getImageForName(name, bundle);
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