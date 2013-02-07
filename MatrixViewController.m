//
//  MatrixViewController.m
//  StackOView
//
//  Created by Daniel Arnaud on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatrixViewController.h"
#import "MatrixCellView.h"
#import "MatrixNavigationController.h"

@interface MatrixViewController ()

@end

@implementation MatrixViewController

//@synthesize view;
@synthesize matrixNavigationController = _matrixNavigationController;
@synthesize viewLayoutStyle = _viewLayoutStyle;

-(id) init
{
	if (self = [super init])
	{
		
	}
	return self;
}
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//		
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[(MatrixView*)self.view reloadData];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mpark--
#pragma MatrixViewDelegate methods

-(void)matrixView:(MatrixView*)matrixView didSelectCell:(MatrixCellView*)cell
{
	MatrixViewController* newMatrixController = [[MatrixViewController alloc] initWithNibName:@"MatrixViewController" bundle:nil];
	[self.matrixNavigationController pushViewController:newMatrixController fromCell:cell animated:YES];
	
}

-(void)matrixView:(MatrixView*)matrixView didDeselectCell:(MatrixPosition*)position
{
	
}

-(void)matrixView:(MatrixView*)matrixView willDisplayCell:(MatrixPosition*)position
{
	
}

#pragma mark--
#pragma MatrixViewDataSource methods

-(MatrixCellView*)matrixView:(MatrixView*)matrixView cellForPosition:(MatrixPosition*)position
{
		
	return nil;
}


-(NSUInteger)numberOfRowsForMatrixView:(MatrixView*)matrixView
{
	return 0;
}


-(NSUInteger)numberOfColumnsForMatrixView:(MatrixView*)matrixView
{
	return 0;
}

-(CGFloat)matrixView:(MatrixView*)matrixView widthForColumn:(NSUInteger)col
{
	return 0;
}
-(CGFloat)matrixView:(MatrixView*)matrixView heightForRow:(NSUInteger)row
{
	return 0;
}

@end
