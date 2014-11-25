/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/

@interface SBClockApplicationIconImageView : UIImageView
- (UIImage *)contentsImage;
@end

/*%group iOS8
%hook SBClockApplicationIconImageView

- (UIImage *)contentsImage {
	UIImage *ret = nil;
	if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad)
		ret = [UIImage imageNamed:@"ClockIconBackgroundSquare~iphone"];
	else
		ret = [UIImage imageNamed:@"ClockIconBackgroundSquare~ipad"];
	if (ret != nil){
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
	} else {
		ret = %orig;
	}
	return ret;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
%end*/

%group all
%hook SBClockApplicationIconImageView
- (id)initWithFrame:(CGRect)frame {
	self = %orig;
	CALayer *hours = [self valueForKey:@"_hours"];
	CALayer *minutes = [self valueForKey:@"_minutes"];
	CALayer *seconds = [self valueForKey:@"_seconds"];
	CALayer *redDot = [self valueForKey:@"_redDot"];
	CALayer *blackDot = [self valueForKey:@"_blackDot"];
	if ([UIImage imageNamed:@"ClockIconHourHand"]){
		hours.contents = (id)[UIImage imageNamed:@"ClockIconHourHand"].CGImage;
	}
	if ([UIImage imageNamed:@"ClockIconMinuteHand"]){
		minutes.contents = (id)[UIImage imageNamed:@"ClockIconMinuteHand"].CGImage;
	}
	if ([UIImage imageNamed:@"ClockIconSecondHand"]){
		seconds.contents = (id)[UIImage imageNamed:@"ClockIconSecondHand"].CGImage;
	}
	if ([UIImage imageNamed:@"ClockIconRedDot"]){
		redDot.contents = (id)[UIImage imageNamed:@"ClockIconRedDot"].CGImage;
	}
	if ([UIImage imageNamed:@"ClockIconBlackDot"]){
		blackDot.contents = (id)[UIImage imageNamed:@"ClockIconBlackDot"].CGImage;
	}
	return self;
}
%end
%end

%ctor {
	/*if (kCFCoreFoundationVersionNumber >= 1140.10){
		%init(iOS8);
	}*/
	%init(all);
}