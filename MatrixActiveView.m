//
//  MatrixActiveView.m
//  StackOView
//
//  Created by Daniel Arnaud on 09/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatrixActiveView.h"
#import "UtilityViewTransition.h"


@implementation MatrixActiveView

CGFloat red;
CGFloat green;
CGFloat blue;
CGFloat alpha; 

CGRect originalRect;

@synthesize highLightColor = _highLightColor;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.highLightColor = [UIColor blueColor];
    }
    return self;
}

- (void)awakeFromNib
{
	self.highLightColor = [UIColor blueColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) printRect:(CGRect)rect
{
	NSLog (@"x: %3.2f, y: %3.2f, w: %3.2f, h: %3.2f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

-(void) highlightOnDrop
{
	originalRect = self.frame;
	[self.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha]; 
	//CGAffineTransform enlarge = CGAffineTransformMakeScale(1.1, 1.1);
	
	CGRect enlargedRect = CGRectMake(originalRect.origin.x - 20, 
									 originalRect.origin.y - 20, 
									 originalRect.size.width + 20, 
									 originalRect.size.height + 20);
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionShowHideTransitionViews 
                     animations:^{self.frame = enlargedRect; self.backgroundColor = self.highLightColor; }
	// animations:^{self.transform = enlarge; self.backgroundColor = self.highLightColor; }
					 completion:^(BOOL finished){[self setStateToNormal];}];
	
}

-(void) highlightOnDropWithColor:(UIColor*)color
{
	normalStateColor = [self.backgroundColor retain];
	CGAffineTransform enlarge = CGAffineTransformMakeScale(1.1, 1.1);
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
                     animations:^{self.transform = enlarge; self.backgroundColor = color; }
					 completion:^(BOOL finished){[self setStateToNormal];}];
}

-(void) setStateToNormal
{
	
	//CGAffineTransform reduce = CGAffineTransformMakeScale(1.0, 1.0);


    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{ self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha]; self.frame = originalRect;}
					 completion:nil];
}


-(void) draggedEnter
{
	NSLog(@"draggedEnter");
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch*	touch		= [touches anyObject];
	
	CGPoint touchPoint	= [touch locationInView:self];
	[super touchesBegan:touches withEvent:event];
	//self.touchInActiveZone = [self touchPoint:touchPoint inActiveZone:self.activeDropZone];
	NSLog(@"MatrixActiveView touchesBegan at %3.2f, %3.2f", touchPoint.x, touchPoint.y);
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	
	
	UITouch*	touch		= [touches anyObject];
	
	
	CGPoint touchPoint	= [touch locationInView:self];
	NSLog(@"MatrixActiveView touched at %3.2f, %3.2f", touchPoint.x, touchPoint.y);
	
	
		
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch*	touch		= [touches anyObject];
	
		CGPoint touchPoint	= [touch locationInView:self];
	NSLog(@"MatrixActiveView touchEnded at %3.2f, %3.2f", touchPoint.x, touchPoint.y);
	[self highlightOnDrop];
	
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touchesCancelled");
	//[super touchesCancelled:touches withEvent:event];
}


@end
