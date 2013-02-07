//
//  MatrixView.h
//  StackOView
//
//  Created by Daniel Arnaud on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatrixCellView.h"
#import "MatrixPosition.h"
#import "MatrixActiveView.h"

@class MatrixView;



@protocol MatrixViewDelegate <NSObject,  UIScrollViewDelegate>

@optional
-(void)matrixView:(MatrixView*)matrixView didSelectCell:(MatrixCellView*)cell;
-(void)matrixView:(MatrixView*)matrixView didDeselectCell:(MatrixCellView*)cell;
-(void)matrixView:(MatrixView*)matrixView willDisplayCell:(MatrixCellView*)cell;

-(CGFloat)matrixView:(MatrixView*)matrixView widthForColumn:(NSUInteger)col;
-(CGFloat)matrixView:(MatrixView*)matrixView heightForRow:(NSUInteger)row;


@end

@protocol MatrixViewDataSource <NSObject>
@required
-(MatrixCellView*)matrixView:(MatrixView*)matrixView cellForPosition:(MatrixPosition*)position;
-(NSUInteger)numberOfRowsForMatrixView:(MatrixView*)matrixView;
-(NSUInteger)numberOfColumnsForMatrixView:(MatrixView*)matrixView;


@optional
-(NSUInteger)matrixView:(MatrixView*)numberOfColumnsForRow:(NSUInteger)row;
-(NSUInteger)matrixView:(MatrixView *)numberOfRowsForColumn:(NSUInteger)column;
- (BOOL)matrixView:(MatrixView *)matrixView canEditCell:(MatrixCellView *)cell;
- (BOOL)matrixView:(MatrixView *)matrixView canMoveCell:(MatrixCellView *)cell;
- (BOOL)matrixView:(MatrixView *)matrixView canMoveCell:(MatrixCellView *)cell toPosition:(MatrixPosition*)position;

 

@end


#define kOutOfBound		-1

typedef enum
{
	MatrixViewActiveZonePositionBottom,
	MatrixViewActiveZonePositionTop
} MatrixViewActiveZonePosition;

typedef enum
{
	MatrixLayoutFlow,
	MatrixLayoutCentered,
	MatrixLayoutStar
} MatrixLayoutStyle;

typedef enum
{
	MatrixRowLayoutCentered,
	MatrixRowLayoutAlignRight,
	MatrixRowLayoutAlignLeft
} MatrixRowLayoutStyle;

typedef enum
{
	MatrixColumnLayoutCentered,
	MatricColumnLayoutAlignTop,
	MatrixColumnLayoutAlignBottom,
} MatrixColumnLayoutStyle;

@interface MatrixView : UIScrollView
{
	@private
	NSMutableArray* cellArray;
	CGRect cellsDisplayZone;
	
	
	@protected
	MatrixCellView* movingCell;
	
}

@property (nonatomic, assign) CGFloat columnWidth;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) IBOutlet id<MatrixViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<MatrixViewDataSource> datasource;
@property (nonatomic, assign, readonly, getter = numberOfRows) NSUInteger rows;
@property (nonatomic, assign, readonly, getter = numberOfColumns) NSUInteger columns;
@property (nonatomic, assign) MatrixCellViewSeparatorStyle separatorStyle;
@property(nonatomic, retain) UIColor *separatorColor;
@property(nonatomic, getter=isEditing) BOOL editing;
@property (nonatomic, assign) CGRect activeDropZone;
@property (nonatomic, assign) IBOutlet MatrixActiveView *activeView;
@property (nonatomic, assign) BOOL showActiveView;
@property (nonatomic, assign) MatrixViewActiveZonePosition activeZonePosition;
@property (nonatomic, assign) BOOL touchInActiveZone;
@property (nonatomic, assign) BOOL activeViewDisplayed;

@property (nonatomic, assign) MatrixLayoutStyle layoutStyle;
@property (nonatomic, assign) MatrixRowLayoutStyle rowLayoutStyle;
@property (nonatomic, assign) MatrixColumnLayoutStyle columnLayoutStyle;
//@property (nonatomic, assign) SEL layoutSelector;



//-(NSUInteger)numberOfRows;
//-(NSUInteger)numberOfColumns;
-(MatrixCellView*)cellForPosition:(MatrixPosition*)position;
-(void)selectCellAtPosition:(MatrixPosition*)position;
-(void)selectMatrixCellView:(MatrixCellView*)cell;
-(void) reloadData;
-(BOOL)switchCell:(MatrixCellView*)cell toEditMode:(BOOL)mode;
-(BOOL) canMoveCell:(MatrixCellView*)cell;
-(void) didEndMovingCell;
-(MatrixPosition*) positionAtPoint:(CGPoint)point;

-(void) printRect:(CGRect)rect;

-(NSUInteger)indexOfPosition:(MatrixPosition*)position;


@end
