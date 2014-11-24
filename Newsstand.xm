/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/

@interface SBNewsstand
+(BOOL)useInternationalAssets;
@end

%group iOS8
%hook SBNewsstandIcon
- (UIImage *)generateIconImage:(int)img {
	UIImage *ret = nil;
	if ([%c(SBNewsstand) useInternationalAssets]){
		if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
			ret = [UIImage imageNamed:@"NewsstandIconInternational~iphone"];
		else
			ret = [UIImage imageNamed:@"NewsstandIconInternational~ipad"];
	} else {
		if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
			ret = [UIImage imageNamed:@"NewsstandIconEnglish~iphone"];
		else
			ret = [UIImage imageNamed:@"NewsstandIconEnglish~ipad"];
	}
	if (ret){
		UIImage *maskImage = nil;
		if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
			maskImage = [UIImage imageWithContentsOfFile:@"/System/Library/PrivateFrameworks/MobileIcons.framework/AppIconMask~iphone.png"];
		else
			maskImage = [UIImage imageWithContentsOfFile:@"/System/Library/PrivateFrameworks/MobileIcons.framework/AppIconMask~ipad.png"];
		UIGraphicsBeginImageContextWithOptions(maskImage.size, YES, 0.0);
		[[UIColor whiteColor] setFill];
		UIRectFill(CGRectMake(0,0,maskImage.size.width,maskImage.size.height));
		[maskImage drawAtPoint:CGPointMake(0,0)];
		maskImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		CGImageRef maskRef = maskImage.CGImage;
		CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
											CGImageGetHeight(maskRef),
											CGImageGetBitsPerComponent(maskRef),
											CGImageGetBitsPerPixel(maskRef),
											CGImageGetBytesPerRow(maskRef),
											CGImageGetDataProvider(maskRef),
											NULL, false);
		CGImageRef masked = CGImageCreateWithMask([ret CGImage], mask);
		CGImageRelease(mask);
		ret = [UIImage imageWithCGImage:masked scale:ret.scale orientation:ret.imageOrientation];
		CGImageRelease(masked);
		return ret;
	} else
		return %orig;
}
%end
%end

%ctor {
	if (kCFCoreFoundationVersionNumber >= 1140.10){
		%init(iOS8);
	}
}