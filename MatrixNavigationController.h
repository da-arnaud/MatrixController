//
//  MatrixNavigationController.h
//  StackOView
//
//  Created by Daniel Arnaud on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "MatrixViewController.h"
#import "MatrixCellView.h"

@class MatrixViewController;


@interface MatrixNavigationController : UIViewController
{
	@private
	NSMutableArray* stack;
	UIBarButtonItem* defaultBackButtonItem;
	@public
	MatrixViewController* root;
}

@property (nonatomic, retain) IBOutlet MatrixViewController* root;
@property (nonatomic, retain, readonly) NSMutableArray* stack;
@property (nonatomic, retain) IBOutlet UINavigationBar* navigationBar;
@property (nonatomic, retain) IBOutlet UIView* containerView;

-(id) initWithRootController:(UIViewController*)rootController;
-(void)pushViewController:(UIViewController*)viewController;
-(void)popViewController;

-(void)pushViewController:(UIViewController*)viewController fromCell:(MatrixCellView*)cell animated:(BOOL)animated;

-(void)pushViewController:(UIViewController*)viewController fromFrame:(CGRect)inFrame animated:(BOOL)animated;

-(void)popViewControllerAnimated:(BOOL)animated;

-(void)pushModalViewController:(UIViewController*)viewController fromFrame:(CGRect)inFrame animated:(BOOL)animated;

-(void)pushModalViewController:(UIViewController*)viewController fromCell:(MatrixCellView*)cell animated:(BOOL)animated;

@end
