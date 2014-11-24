%group Preferences
%hook PrefsListController
- (id)specifiers {
	NSMutableDictionary *iconCache = [NSMutableDictionary new];
	NSDictionary *origIconCache = [self valueForKey:@"_iconCache"];
	for (NSString *key in origIconCache){
		UIImage *icon = [origIconCache objectForKey:key];
		if ([UIImage imageNamed:key]){
			icon = [UIImage imageNamed:key];
		}
		[iconCache setObject:icon forKey:key];
	}
	[self setValue:iconCache forKey:@"_iconCache"];
	return %orig;
}
%end
%end

%ctor {
	if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.Preferences"]){
		%init(Preferences);
	}
}