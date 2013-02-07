//
//  MatrixCellView.h
//  StackOView
//
//  Created by Daniel Arnaud on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MatrixPosition.h"


@class MatrixView;

typedef enum {
    MatrixCellViewSelectionStyleNone,
    MatrixCellViewSelectionStyleBlue,
    MatrixCellViewSelectionStyleGray,
	MatrixCellViewSelectionCustomView,
	MatrixCellViewSelectionInverseVideo
} MatrixCellViewSelectionStyle;

typedef enum {
	MatrixCellViewStyleNormal,
	MatrixCellViewStyleRounded,
	MatrixCellViewStyleCustom
} MatrixCellViewStyle;

typedef enum {
    MatrixCellViewSeparatorStyleNone,
    MatrixCellViewSeparatorStyleSingleLine,
    //MatrixCellViewSeparatorStyleSingleLineEtched   
} MatrixCellViewSeparatorStyle;

//#define kSwitchToEditModeDelay		1.5

#define kEditTimerUserInfoKey		@"EditBoolValue"

@interface MatrixCellView : UIView
{
		@protected
	CGPoint					touchPoint;
	
	@private				
	MatrixView*				matrixView;
	NSUInteger				column;
	NSUInteger				row;

	//UIColor* bufferedBackgroundColor;
	//NSTimer* switchEditModeTimer;
	

}

@property (nonatomic, assign) BOOL selectable;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign, getter = isMoving) BOOL moving;
@property (nonatomic, retain) IBOutlet UIView* 		backgroundView;
//@property (nonatomic, assign) NSUInteger			row;
//@property (nonatomic, assign) NSUInteger			column;
@property (nonatomic, assign) MatrixCellViewSelectionStyle selectionStyle;
@property (nonatomic, assign) MatrixCellViewStyle style;
@property (nonatomic, assign, readonly, getter = isEditing) BOOL editing;

@property (nonatomic, retain) MatrixPosition* position;

@property (nonatomic, retain) UIColor* bufferedBackgroundColor;


//@property (nonatomic, assign) CGFloat switchToEditModeDelay;

-(void) setMatrixView:(MatrixView*)view;

- (id)initWithFrame:(CGRect)frame position:(MatrixPosition*)position;
//-(void)selectMatrixCellView:(MatrixCellView*)cell;

@end
