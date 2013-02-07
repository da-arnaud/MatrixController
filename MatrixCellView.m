//
//  MatrixCellView.m
//  StackOView
//
//  Created by Daniel Arnaud on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MatrixCellView.h"
#import "UIImage(Extension).h"
#import "MatrixView.h"

#define defaultIconeProportion	0.7
#define defaultTitleProportion	0.2

@interface MatrixCellView ()

-(void) switchToEditMode:(NSTimer*)timer;

@end

@implementation MatrixCellView

@synthesize selectable = _selectable;
@synthesize selected = _selected;
@synthesize moving = _moving;
@synthesize backgroundView = _backgroundView;

//@synthesize column = _column;
//@synthesize row = _row;

@synthesize selectionStyle = _selectionStyle;
@synthesize style = _style;
@synthesize editing = _editing;
@synthesize bufferedBackgroundColor = _bufferedBackgroundColor;

@synthesize position;

//@synthesize switchToEditModeDelay = _switchToEditModeDelay;



- (id)initWithFrame:(CGRect)frame position:(MatrixPosition*)pos
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        // Initialization code
		self.selectable = YES;
		self.backgroundView = [[UIView alloc] initWithFrame:frame];
		[self.backgroundView release];
		
//		self.backgroundView.backgroundColor = [UIColor blackColor];
		[self addSubview:self.backgroundView];
		
		[self.backgroundView release];
//		self.column = pos.col;
//		self.row = pos.row;
		self.position = pos;
		//[self setupView:frame];
		_editing = NO;
		_moving = NO;
		//_switchToEditModeDelay = kSwitchToEditModeDelay;
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code UITableViewCell
}
*/

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	self.selectable = YES;
	_editing = NO;
	_moving = NO;
	//_switchToEditModeDelay = kSwitchToEditModeDelay;
//	self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
//	[self.backgroundView release];
//	[self addSubview:self.backgroundView];
//	[self.backgroundView release];
}

-(void) setMatrixView:(MatrixView*)view
{
	matrixView = view;
}

-(void) setStyle:(MatrixCellViewStyle)style
{
	_style = style;
	if (style == MatrixCellViewStyleRounded) {
		self.layer.cornerRadius = 10.0;
		self.layer.borderColor = [[UIColor grayColor] CGColor];
		self.layer.borderWidth = 2.0;
		
	}
}

-(void) setCustomStyleWithCornerRadius:(CGFloat)radius borderColor:(UIColor*)color borderWidth:(CGFloat)borderWidth
{
	_style = MatrixCellViewStyleCustom;
	self.layer.cornerRadius = radius;
	self.layer.borderColor = [color CGColor];
	self.layer.borderWidth = borderWidth;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (_selectable)
	{
		UITouch*	touch		= [touches anyObject];
		
		touchPoint	= [touch locationInView:self];
		
		self.selected = YES;
	}
	//BOOL moveToEditMode = !_editing;
//	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:moveToEditMode] forKey:kEditTimerUserInfoKey];
//	switchEditModeTimer = [[NSTimer scheduledTimerWithTimeInterval:_switchToEditModeDelay target:self selector:@selector(switchToEditMode:) userInfo:userInfo repeats:NO] retain];
	
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	

	UITouch*	touch		= [touches anyObject];
	
	self.selected = NO;
	if (self.moving == NO)
	{
		self.moving = [matrixView canMoveCell:self];
		//NSLog(@"should move");
		if (self.moving) {
			[matrixView bringSubviewToFront:self];
		}
	}
	
	touchPoint	= [touch locationInView:self];
	
	//NSLog(@"moved in cell");
//	[switchEditModeTimer invalidate];
//	[switchEditModeTimer release];
	
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.selectable)
	{
		if (self.selected)
		{
			[matrixView selectMatrixCellView:self];
			self.selected = NO;
		}
	}
//	[switchEditModeTimer invalidate];
//	[switchEditModeTimer release];
	_editing = [matrixView switchCell:self toEditMode:NO];
	if (_moving)
	{
		self.moving = NO;
		[matrixView didEndMovingCell];
	}
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.selectable)
	{
		self.selected = NO;
	}
	NSLog(@"touchesCancelled");
	[super touchesCancelled:touches withEvent:event];
}

-(void) setSelected:(BOOL)selected
{
	_selected = selected;
	
	if (_selected)
	{
		//bufferedBackgroundColor = [self.backgroundView.backgroundColor retain];
		self.bufferedBackgroundColor = self.backgroundView.backgroundColor;
		switch (_selectionStyle) {
			case MatrixCellViewSelectionStyleNone:
				break;
			case MatrixCellViewSelectionStyleBlue:
				self.backgroundView.backgroundColor = [UIColor blueColor];
				 break;
			case MatrixCellViewSelectionStyleGray:
				 self.backgroundView.backgroundColor = [UIColor lightGrayColor];
				 break;
				
			default:
				break;
		}
	}
	else 
	{
		//self.backgroundView.backgroundColor = bufferedBackgroundColor;
		//[bufferedBackgroundColor release];
		self.backgroundView.backgroundColor = self.bufferedBackgroundColor;
	}
				 
}

-(void) switchToEditMode:(NSTimer*)timer
{
	NSLog(@"switchToEditMode");
	BOOL value = [[timer.userInfo objectForKey:kEditTimerUserInfoKey] boolValue];
	if (value)
	{
		_editing = [matrixView switchCell:self toEditMode:value];
		//[self setEditing:[matrixView switchCell:self toEditMode:value]];
		if (_editing) {
			self.alpha = self.alpha/2.0;
			//NSLog(@"editing is true");
			[self setSelected:NO];
		}
		else 
		{
			self.alpha = self.alpha*2.0;
			//NSLog(@"editing is false");
		}
	}
	else 
	{
		self.alpha = self.alpha*2.0;
		_editing = NO;
	}
	
}

-(void) setMoving:(BOOL)moving
{
	_moving = moving;
//	if(_moving)
//	{
//		self.alpha = self.alpha/2.0;
//	}
//	else 
//	{
//		self.alpha = self.alpha*2.0;
//	}
}

-(MatrixPosition*)position
{
	return [MatrixPosition positionWithRow:row column:column];
}

-(void)setPosition:(MatrixPosition *)inPosition
{
	column = inPosition.col;
	row = inPosition.row;
}

-(void) dealloc
{
	[super dealloc];
}
@end
