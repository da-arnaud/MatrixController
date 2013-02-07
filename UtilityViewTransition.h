//
//  UtilityViewTransition.h
//  MAB
//
//  Created by Daniel Arnaud on 04/10/10.
//  Copyright 2010 MeoSense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface UtilityViewTransition : NSObject {

}

+ (void) transitionForView:(UIView *)view type:(NSString *)type subtype:(NSString *)subtype;
+ (void) transitionForView:(UIView *)view type:(NSString *)type subtype:(NSString *)subtype delegate:(id)delegate;
+ (void) transitionForView:(UIView *)view type:(NSString *)type subtype:(NSString *)subtype duration:(NSTimeInterval)duration;
+ (void) transitionForView:(UIView *)view type:(NSString *)type subtype:(NSString *)subtype duration:(NSTimeInterval)duration delegate:(id)delegate;
+ (float) transitionDelay;
@end
