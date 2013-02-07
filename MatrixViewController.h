//
//  MatrixViewController.h
//  StackOView
//
//  Created by Daniel Arnaud on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatrixView.h"
#import "MatrixNavigationController.h"
//@class MatrixNavigationController;

@interface MatrixViewController : UIViewController <MatrixViewDelegate, MatrixViewDataSource>

@property (nonatomic, retain) IBOutlet MatrixNavigationController* matrixNavigationController;
//@property (nonatomic, retain) IBOutlet MatrixView* view;
@property (nonatomic, assign) MatrixLayoutStyle viewLayoutStyle;


@end
