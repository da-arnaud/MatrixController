//
//  MatrixView.m
//  StackOView
//
//  Created by Daniel Arnaud on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatrixView.h"

@interface MatrixView ()


-(NSUInteger)numberOfRows;
-(NSUInteger)numberOfColumns;
-(MatrixCellView*)cellForPosition:(MatrixPosition*)position;
-(CGFloat) defaultWidth;
-(CGFloat) defaultHeight;
-(void) setSeparatorForCell:(MatrixCellView*)cell;
-(NSUInteger) columnForX:(CGFloat)x;
-(NSUInteger) rowForY:(CGFloat)y;
-(void) didFinishMoving;
-(void) displayActiveView;
-(void) hideActiveView;
-(BOOL) touchPoint:(CGPoint)point inRect:(CGRect)zone;
-(void) addObservers;
-(void)touchInActiveZoneValueChanged;

@end

@implementation MatrixView

@synthesize columnWidth;
@synthesize rowHeight;
@synthesize delegate;
@synthesize datasource;
@synthesize rows = _rows;
@synthesize columns = _columns;
@synthesize separatorStyle = _separatorStyle;
@synthesize separatorColor = _separatorColor;
@synthesize editing = _editing;
@synthesize activeDropZone = _activeDropZone;
@synthesize activeView = _activeView;
@synthesize showActiveView = _showActiveView;
@synthesize activeZonePosition = _activeZonePosition;
@synthesize touchInActiveZone = _touchInActiveZone;
@synthesize activeViewDisplayed = _activeViewDisplayed;

@synthesize layoutStyle = _layoutStyle;
@synthesize rowLayoutStyle = _rowLayoutStyle;
@synthesize columnLayoutStyle = _columnLayoutStyle;
//@synthesize layoutSelector = _layoutSelector;


CGRect movingCellOriginalRect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.separatorStyle = MatrixCellViewSeparatorStyleNone;
		self.clipsToBounds=YES;
		self.touchInActiveZone = NO;
		self.layoutStyle = MatrixLayoutFlow;
		//[self addObservers];
		[self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];	
		[self addObserver:self forKeyPath:@"_touchInActiveZone" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

-(void) printRect:(CGRect)rect
{
	NSLog (@"x: %3.2f, y: %3.2f, w: %3.2f, h: %3.2f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.separatorStyle = MatrixCellViewSeparatorStyleNone;
	//[self addObservers];
	self.clipsToBounds=YES;
	self.touchInActiveZone = NO;
	self.layoutStyle = MatrixLayoutFlow;
	 [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];	
	[self addObserver:self forKeyPath:@"_touchInActiveZone" options:NSKeyValueObservingOptionNew context:NULL];
	
}

-(void) setActiveZonePosition:(MatrixViewActiveZonePosition)activeZonePosition
{
	_activeZonePosition = activeZonePosition;
	if (self.activeView)
	{
		self.activeDropZone = self.activeView.frame;
		if (!self.showActiveView) {
			CGRect actualRect = self.activeView.frame;
			if (self.activeZonePosition == MatrixViewActiveZonePositionBottom)
			{
				
				self.activeView.frame = CGRectMake(actualRect.origin.x, 
												   actualRect.origin.y+actualRect.size.height, 
												   actualRect.size.width, 
												   actualRect.size.height);
			}
			else if (self.activeZonePosition == MatrixViewActiveZonePositionTop)
			{
				self.activeView.frame = CGRectMake(actualRect.origin.x, 
												   actualRect.origin.y-actualRect.size.height, 
												   actualRect.size.width, 
												   actualRect.size.height);
			}
		}
		[self bringSubviewToFront:self.activeView];
	}
}

-(void) addObservers
{
	[self addObserver:self
			  forKeyPath:@"_touchInActiveZone"
                 options:(NSKeyValueObservingOptionNew |
						  NSKeyValueObservingOptionOld)
				 context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	if ([keyPath isEqualToString:@"contentOffset"])
	{
		CGPoint offSet = self.contentOffset;
		//NSLog(@"content offset x: %3.2f, y: %3.2f", offSet.x, offSet.y);
		CGAffineTransform move = CGAffineTransformMakeTranslation(offSet.x, offSet.y);
		self.activeView.transform = move;
		
		CGFloat yPosition = self.activeViewDisplayed ?  self.activeView.frame.origin.y : self.activeView.frame.origin.y - self.activeView.frame.size.height;

		self.activeDropZone = CGRectMake(self.activeView.frame.origin.x, 
										 yPosition, 
										 self.activeView.frame.size.width, 
										 self.activeView.frame.size.height);
	}	
	else if ([keyPath isEqualToString:@"_touchInActiveZone"])
	{
		NSLog(@"value changed for keypath: %@", keyPath);
		[self touchInActiveZoneValueChanged];
	}
	
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
	
    BOOL automatic = NO;
    if ([theKey isEqualToString:@"_touchInActiveZone"]) {
        automatic = NO;
    } else {
        automatic=[super automaticallyNotifiesObserversForKey:theKey];
    }
    return automatic;
}

/* old stuff
-(void) setTouchInActiveZone:(BOOL)touchInActiveZone
{
	BOOL oldValue = _touchInActiveZone;
	
    _touchInActiveZone=touchInActiveZone;
	if (_touchInActiveZone!=oldValue)
	{
		[self willChangeValueForKey:@"_touchInActiveZone"];
		[self touchInActiveZoneValueChanged];
		[self didChangeValueForKey:@"_touchInActiveZone"];
	}
	
    //[self didChangeValueForKey:@"setTouchInActiveZone"];
}
*/
-(void) setTouchInActiveZone:(BOOL)touchInActiveZone
{
//	BOOL oldValue = _touchInActiveZone;
//	
//    
	if (_touchInActiveZone!=touchInActiveZone)
	{
		[self willChangeValueForKey:@"_touchInActiveZone"];
		_touchInActiveZone=touchInActiveZone;
		[self didChangeValueForKey:@"_touchInActiveZone"];
	}
	
}

-(void)selectMatrixCellView:(MatrixCellView*)cell
{
	//NSLog(@"selected cell @ position %d, %d", cell.position.col, cell.position.row);
	if ([self.delegate respondsToSelector:@selector(matrixView:didSelectCell:)])
		{
			[self.delegate matrixView:self didSelectCell:cell];
		}
}

-(void)touchInActiveZoneValueChanged
{
	if (_touchInActiveZone) {
		[self displayActiveView];
		NSLog(@"touchInActiveZoneValueChanged displaying");
	}
	else 
	{
		[self hideActiveView];
		NSLog(@"touchInActiveZoneValueChanged hiding");
	}
}

-(NSUInteger)numberOfRows
{
	
	return [self.datasource numberOfRowsForMatrixView:self];
}

-(NSUInteger)numberOfColumns
{
	return [self.datasource numberOfColumnsForMatrixView:self];
}

-(MatrixCellView*)cellForPosition:(MatrixPosition *)position
{
	if ([self.datasource respondsToSelector:@selector(matrixView:cellForPosition:)])
	{
		MatrixCellView* cell = [self.datasource matrixView:self cellForPosition:position];
//		cell.row = position.row;
//		cell.column = position.col;
		cell.position = position;
		return cell;
	}
	else 
	{
		return nil;
	}
}

-(void)selectCellAtPosition:(MatrixPosition*)position
{

}

-(CGFloat) defaultWidth
{
	return self.columnWidth!=0.0 ? self.columnWidth : self.frame.size.width / [self numberOfColumns];
}

-(CGFloat) defaultHeight
{
	return self.rowHeight!=0.0 ? self.rowHeight : self.frame.size.height / [self numberOfRows];
}

-(CGFloat) widthForColumn:(NSUInteger)column
{
	if ([self.delegate respondsToSelector:@selector(matrixView:widthForColumn:)])
	{
		return [self.delegate matrixView:self widthForColumn:column] ;
	}
	else 
	{
		return [self defaultWidth]; 
	}
}

-(CGFloat) heightForRow:(NSUInteger)row
{
	if ([self.delegate respondsToSelector:@selector(matrixView:hieghtForRow:)])
	{
		return [self.delegate matrixView:self heightForRow:row] ;
	}
	else 
	{
		return [self defaultHeight]; 
	}
}

-(void)setSeparatorForCell:(MatrixCellView *)cell
{
	switch (self.separatorStyle) {
		case MatrixCellViewSeparatorStyleNone:
			break;
		case MatrixCellViewSeparatorStyleSingleLine:
			cell.layer.borderWidth = 0.5;
			cell.layer.borderColor = self.separatorColor == nil ? [[UIColor lightGrayColor]CGColor]: [self.separatorColor CGColor];
			break;
			
		default:
			break;
	}
}

-(void) reloadData
{
	if (cellArray) {
		[cellArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[cellArray removeAllObjects];
		[cellArray release];
		cellArray = nil;
		_rows = 0;
		_columns = 0;
	}
	
	cellArray = [[NSMutableArray alloc] initWithCapacity:0];
	_columns = self.numberOfColumns;
	_rows = self.numberOfRows;
	/*************************************/
	if (self.layoutStyle == MatrixLayoutFlow)
		[self flowLayout];
	else if (self.layoutStyle == MatrixLayoutCentered)
		[self centeredLayout];
	
	
}

-(void) flowLayout
{
	CGFloat totalWidth = 0.0;
	CGFloat totalHeight = 0.0;
	for (int r = 0 ; r < _rows ; r++)
	{
		rowHeight = [self.delegate matrixView:self heightForRow:r];
		totalHeight += rowHeight;
		totalWidth = 0.0;
		for (int c = 0 ; c < _columns ; c++)
		{
			MatrixPosition* position = [MatrixPosition positionWithRow:r column:c];
			MatrixCellView* cell = [self cellForPosition:position];
			if (cell)
			{
				columnWidth = [self.delegate matrixView:self widthForColumn:c];
				totalWidth += columnWidth;
				
				CGPoint origin = CGPointMake(c*columnWidth, r*rowHeight);
				CGRect cellFrame = CGRectMake(origin.x, origin.y, cell.frame.size.width, cell.frame.size.height);
				
				[cell setFrame:cellFrame];
				[cell setMatrixView:self];
				[self setSeparatorForCell:cell];
				[self addSubview:cell];
				[cellArray addObject:cell];
			}
			//[cell release];
			
			
		}
	}
	self.contentSize = CGSizeMake(totalWidth, totalHeight);
	cellsDisplayZone = CGRectMake(0.0, 0.0, totalWidth, totalHeight);
}

-(void) centeredLayout
{
	CGFloat totalWidth = 0.0;
	CGFloat totalHeight = 0.0;
	for (int r = 0 ; r < _rows ; r++)
	{
		rowHeight = [self.delegate matrixView:self heightForRow:r];
		totalHeight += rowHeight;
		totalWidth = 0.0;
		for (int c = 0 ; c < _columns ; c++)
		{
			columnWidth = [self.delegate matrixView:self widthForColumn:c];
			totalWidth += columnWidth;
		}
	}
	
	CGSize displayZoneSize = CGSizeMake(totalWidth, totalHeight);
	CGSize viewSize = self.frame.size;
	
	CGFloat horizontalOrigin = (viewSize.width - displayZoneSize.width) / 2;
	CGFloat verticalOrigin = (viewSize.height - displayZoneSize.height) / 2;
	
	for (int r = 0 ; r < _rows ; r++)
	{
		rowHeight = [self.delegate matrixView:self heightForRow:r];
		//totalHeight += rowHeight;
		//totalWidth = 0.0;
		for (int c = 0 ; c < _columns ; c++)
		{
			MatrixPosition* position = [MatrixPosition positionWithRow:r column:c];
			MatrixCellView* cell = [self cellForPosition:position];
			columnWidth = [self.delegate matrixView:self widthForColumn:c];
			
			CGPoint origin = CGPointMake(c*columnWidth, r*rowHeight);
			CGRect cellFrame = CGRectMake(origin.x + horizontalOrigin, 
										  origin.y + verticalOrigin, 
										  cell.frame.size.width, 
										  cell.frame.size.height);
			
			[cell setFrame:cellFrame];
			[cell setMatrixView:self];
			[self setSeparatorForCell:cell];
			[self addSubview:cell];
			[cellArray addObject:cell];
			//[cell release];
			
			
		}
	}
	self.contentSize = CGSizeMake(totalWidth, totalHeight);
	cellsDisplayZone = CGRectMake(horizontalOrigin, verticalOrigin, totalWidth, totalHeight);

}


/*
-(void) displayActiveView
{
	
	CGAffineTransform moveIn ;
	if (self.activeZonePosition == MatrixViewActiveZonePositionBottom)
	{
		moveIn = CGAffineTransformMakeTranslation(0, -self.activeView.frame.size.height);
	}
	else if (self.activeZonePosition == MatrixViewActiveZonePositionTop)
	{
		moveIn = CGAffineTransformMakeTranslation(0, +self.activeView.frame.size.height);
	}
	
	 [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
	 animations:^{self.activeView.transform = moveIn;}
	 completion:nil];
	self.activeViewDisplayed = YES;
	[self bringSubviewToFront:self.activeView];
	//[self.activeView becomeFirstResponder];

}
*/
-(void) displayActiveView
{
	CGFloat verticalTranslation;
	if (self.activeZonePosition == MatrixViewActiveZonePositionBottom)
	{
		verticalTranslation = -self.activeView.frame.size.height;
	}
	else if (self.activeZonePosition == MatrixViewActiveZonePositionTop)
	{
		verticalTranslation = +self.activeView.frame.size.height;
	}
	
	CGRect translatedRect = CGRectMake(self.activeView.frame.origin.x, 
									   self.activeView.frame.origin.y + verticalTranslation, 
									   self.activeView.frame.size.width, 
									   self.activeView.frame.size.height);
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
					 animations:^{self.activeView.frame = translatedRect;}
					 completion:nil];
	self.activeViewDisplayed = YES;
	[self bringSubviewToFront:self.activeView];
	[self bringSubviewToFront:movingCell];
}

/*
-(void) hideActiveView
{
	
	CGAffineTransform moveOut;
	if (self.activeZonePosition == MatrixViewActiveZonePositionBottom)
	{
		moveOut = CGAffineTransformMakeTranslation(0, +self.activeView.frame.size.height);
	}
	else if (self.activeZonePosition == MatrixViewActiveZonePositionTop)
	{
		moveOut = CGAffineTransformMakeTranslation(0, -self.activeView.frame.size.height);
	}
	
	[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
					 animations:^{self.activeView.transform = moveOut;}
					 completion:nil];
	self.activeViewDisplayed = NO;
	//[self.activeView resignFirstResponder];
}
 */

-(void) hideActiveView
{
	CGFloat verticalTranslation;
	if (self.activeZonePosition == MatrixViewActiveZonePositionBottom)
	{
		verticalTranslation = +self.activeView.frame.size.height;
	}
	else if (self.activeZonePosition == MatrixViewActiveZonePositionTop)
	{
		verticalTranslation = -self.activeView.frame.size.height;
	}
	
	CGRect translatedRect = CGRectMake(self.activeView.frame.origin.x, 
									   self.activeView.frame.origin.y + verticalTranslation, 
									   self.activeView.frame.size.width, 
									   self.activeView.frame.size.height);
	[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
					 animations:^{self.activeView.frame = translatedRect;}
					 completion:nil];
	self.activeViewDisplayed = NO;
}


- (void)observeContentOffsetHandler:(NSValue *)aContentOffset
{
	NSLog(@"observeContentOffsetHandler");
}

//-(void) addSubview:(MatrixCellView *)cellView
//{
//	[cellView setMatrixView:self];
//	[super addSubview:cellView];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch*	touch		= [touches anyObject];
	
	CGPoint touchPoint	= [touch locationInView:self];
	[super touchesBegan:touches withEvent:event];
	self.touchInActiveZone = [self touchPoint:touchPoint inRect:self.activeDropZone];
	if (self.touchInActiveZone)
		[self.activeView touchesBegan:touches withEvent:event];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	
	
	UITouch*	touch		= [touches anyObject];
	
	//touchPoint	= [touch locationInView:self];
	//if (self.moving) {
		CGPoint touchPoint	= [touch locationInView:self];
		//NSLog(@"moved in MatrixView to %3.2f, %3.2f", touchPoint.x, touchPoint.y);
	movingCell.center = touchPoint;
	
	[self setTouchInActiveZone:[self touchPoint:touchPoint inRect:self.activeDropZone]];
	//NSLog(@"in active zone %d", _touchInActiveZone);
	
	
	
	//}
	//NSLog(@"moved in view");
	
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch*	touch		= [touches anyObject];
	_editing = NO;
	CGPoint touchPoint	= [touch locationInView:self];
	//NSLog(@"stopped at %3.2f, %3.2f", touchPoint.x, touchPoint.y);
	[self printRect:self.activeDropZone];
	if (movingCell)
	{
		BOOL inActiveZone = [self touchPoint:touchPoint inRect:self.activeDropZone];
		if (inActiveZone)
		{
			
			[self.activeView touchesEnded:touches withEvent:event];
			
			//bring the cell back to it's place. 
			[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
							 animations:^{movingCell.frame = movingCellOriginalRect;}
							 completion:nil];
		}
		else 
		{
			MatrixPosition* dropPosition = [self positionAtPoint:touchPoint];	
			NSLog(@"movingCell %@", [movingCell description]);
			BOOL canMove = [self.datasource matrixView:self canMoveCell:movingCell toPosition:dropPosition];
			
			if (!dropPosition) //we are not over any cell, and we are not in teh activeZOne, so we bring the cell back
			{
				[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
								 animations:^{movingCell.frame = movingCellOriginalRect;}
								 completion:nil];
			}
			else 
			{
				if (canMove)
				{
					NSUInteger indexOfDropCell = [self indexOfPosition:dropPosition];
					MatrixCellView* dropCellView = [cellArray objectAtIndex:indexOfDropCell];
					
					MatrixPosition* movePosition = movingCell.position;
					
					CGRect dropCellFrame = dropCellView.frame;
					
					NSUInteger indexOfMovingCell = [self indexOfPosition:movePosition];
					
					[cellArray exchangeObjectAtIndex:indexOfMovingCell withObjectAtIndex:indexOfDropCell];
					
					[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
									 animations:^{movingCell.frame = dropCellFrame; [self bringSubviewToFront:dropCellView]; dropCellView.frame = movingCellOriginalRect; }
									 completion:nil];
					
					
					MatrixPosition* buffer = movingCell.position;
					//		movingCell.column = dropCellView.position.col;
					//		movingCell.row = dropCellView.position.row;
					//		dropCellView.column = buffer.col;
					//		dropCellView.row = buffer.row;
					movingCell.position = dropCellView.position;
					dropCellView.position = buffer;
					[self didFinishMoving];

				}
				else 
				{
					[UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
									 animations:^{movingCell.frame = movingCellOriginalRect;}
									 completion:nil];
				}
			}
		}

	}
	if (self.activeViewDisplayed)
		[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(hideActiveView) userInfo:nil repeats:NO];
		//[self hideActiveView];
	_touchInActiveZone = NO;
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch*	touch		= [touches anyObject];
	CGPoint touchPoint	= [touch locationInView:self];
	BOOL inActiveZone = [self touchPoint:touchPoint inRect:self.activeDropZone];
	if (inActiveZone)
		[self.activeView touchesCancelled:touches withEvent:event];
	[super touchesCancelled:touches withEvent:event];
}


-(BOOL) touchPoint:(CGPoint)point inRect:(CGRect)rect
{
	BOOL inW =  (point.x > rect.origin.x) && (point.x < rect.origin.x+rect.size.width);
	BOOL inH = (point.y > rect.origin.y) && (point.y < rect.origin.y+rect.size.height);
	
	
	
	return inW && inH;
}

-(BOOL)switchCell:(MatrixCellView*)cell toEditMode:(BOOL)mode 
{
	if (mode)
	{
		if ([self.datasource respondsToSelector:@selector(matrixView:canEditCell:)])
			 {
				 if([self.datasource matrixView:self canEditCell:cell])
				 {
					 _editing = mode;
					 return YES;
				 }
				 else 
				 {
					 _editing = NO;
					 return NO;
				 }
			 }
		else 
		{
			_editing = NO;
			return NO;
		}
	}
	else 
	{
		_editing = NO;
		return NO;
	}
	
}

-(BOOL) canMoveCell:(MatrixCellView*)cell
{
	if ([self.datasource respondsToSelector:@selector(matrixView:canMoveCell:)]) {
		BOOL result =  [self.datasource matrixView:self canMoveCell:cell];
		if (result)
		{
			self.scrollEnabled = NO;
			movingCell = cell;
			movingCellOriginalRect = movingCell.frame;
		}
		return result;
	}
	else 
	{
		movingCell = nil;
		return NO;
	}
	
}

-(void) didEndMovingCell
{
	self.scrollEnabled = YES;
}

-(NSUInteger)indexOfPosition:(MatrixPosition*)position
{
	NSUInteger row = position.row;
	NSUInteger col = position.col;
	
	return row*self.columns + col;
}

-(NSUInteger) columnForX:(CGFloat)x
{
	
	CGFloat aggregatedWidth = cellsDisplayZone.origin.x;
	for (int col = 0 ; col < self.numberOfColumns ; col++)
	{
		aggregatedWidth += [self widthForColumn:col];
		if (aggregatedWidth > x)
			return col;
	}
	return kOutOfBound;
}

-(NSUInteger) rowForY:(CGFloat)y
{
	CGFloat aggregatedHeight = cellsDisplayZone.origin.y;
	for (int row = 0 ; row < self.numberOfRows ; row++)
	{
		aggregatedHeight += [self heightForRow:row];
		if (aggregatedHeight > y)
			return row;
	}
	return kOutOfBound;

}

-(MatrixPosition*) positionAtPoint:(CGPoint)point
{
	if (![self touchPoint:point inRect:cellsDisplayZone])
	{
		return nil;
	}
	else 
	{
		NSUInteger col = [self columnForX:point.x];
		NSUInteger row = [self rowForY:point.y];
		//row = row < self.numberOfRows ? row : self.numberOfRows-1;
		return [MatrixPosition positionWithRow:row column:col];
	}
	
}

-(void) didFinishMoving
{
	movingCell = nil;
}



@end
