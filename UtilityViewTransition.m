//
//  UtilityViewTransition.m
//  MAB
//
//  Created by Daniel Arnaud on 04/10/10.
//  Copyright 2010 MeoSense. All rights reserved.
//

#import "UtilityViewTransition.h"

#define __DELAY__ 0.7

@implementation UtilityViewTransition

+ (void) transitionForView:(UIView *)view type:(NSString *)type subtype:(NSString *)subtype duration:(NSTimeInterval)duration {
	CATransition *animation = [CATransition animation];
	[animation setType:type];
	
	if (subtype) {
		[animation setSubtype:subtype];
	}
	
	[animation setDuration:duration];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[view.layer addAnimation:animation forKey:@"genericTransition"];		
}

+ (void) transitionForView:(UIView *)view type:(NSString *)type subtype:(NSString *)subtype duration:(NSTimeInterval)duration delegate:(id)delegate {
	CATransition *animation = [CATransition animation];
	[animation setType:type];
	
	if (subtype) {
		[animation setSubtype:subtype];
	}
	
	[animation setDuration:duration];
	[animation setDelegate:delegate];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[view.layer addAnimation:animation forKey:@"genericTransition"];		
}

+ (void) transitionForView:(UIView *)view type:(NSString *)type subtype:(NSString *)subtype {
	[self transitionForView:view type:type subtype:subtype duration:__DELAY__];
}

+ (void) transitionForView:(UIView *)view type:(NSString *)type subtype:(NSString *)subtype delegate:(id)delegate {
	[self transitionForView:view type:type subtype:subtype duration:__DELAY__ delegate:delegate];
}

+(float) transitionDelay {
	return __DELAY__;
}

@end
