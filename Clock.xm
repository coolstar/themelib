/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.
*/

@interface SBClockApplicationIconImageView : UIImageView
- (UIImage *)contentsImage;
@end

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
	%init(all);
}