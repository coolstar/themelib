@interface _UIAssetManager : NSObject
	@property (readonly) NSBundle *bundle;
	@property (readonly) NSString *carFileName;
@end

@interface UIImage (Private)
	+ (UIImage *)kitImageNamed:(NSString *)name;
@end

static BOOL isAssetManagerNotUIKit(_UIAssetManager *manager){
	if ([manager.carFileName isEqualToString:@"UIKit_Artwork"] && [manager.bundle.bundlePath isEqualToString:@"/System/Library/Frameworks/UIKit.framework/Artwork.bundle"]){
		return NO;
	}
	return YES;
}

static UIImage *getImageForName(NSString *name, NSBundle *bundle){
	NSDictionary *wbPlist = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.saurik.WinterBoard.plist"];
	NSArray *themes = wbPlist[@"Themes"];
	
	for (NSDictionary *theme in themes)
	{
		if ([theme[@"Active"] boolValue])
		{
			NSString *themeName = theme[@"Name"];
			NSString *path = [NSString stringWithFormat:@"/Library/Themes/%@.theme/Bundles/%@/%@",themeName,bundle.bundleIdentifier,name];
			if ([UIImage imageWithContentsOfFile:path])
				return [UIImage imageWithContentsOfFile:path];
		}
	}
	return nil;
}

%group iOS8
%hook _UIAssetManager
- (UIImage *)imageNamed:(NSString *)name {
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

- (id)imageNamed:(id)name scale:(float)arg2 idiom:(int)arg3 subtype:(unsigned int)arg4 {
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

- (UIImage *)imageNamed:(NSString *)name idiom:(int)arg2 {
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

- (UIImage *)imageNamed:(NSString *)name idiom:(int)arg2 subtype:(unsigned int)arg3 {
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

- (UIImage *)imageNamed:(NSString *)name withTrait:(id)arg2 {
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

%ctor {
	if (kCFCoreFoundationVersionNumber >= 1140.10){
		%init(iOS8);
	}
}