//
//  MatrixNavigationController.m
//  StackOView
//
//  Created by Daniel Arnaud on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatrixNavigationController.h"
#import "MatrixViewController.h"

@interface MatrixNavigationController ()


@end


@implementation MatrixNavigationController

@synthesize stack = _stack;
@synthesize root = _root;
@synthesize navigationBar = _navigationBar;
@synthesize containerView = _containerView;

-(id) initWithRootController:(MatrixViewController*)rootController
{
	if (self = [super init])
	{
		//CGRect masterFrame = [[[UIApplication sharedApplication] keyWindow] frame];
		CGRect masterFrame = [[UIScreen mainScreen] bounds];
		self.view = [[[UIView alloc] initWithFrame:masterFrame] autorelease];
		self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
		[self.view addSubview:self.navigationBar];
		self.containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, masterFrame.size.height-44)] autorelease];
		[self.view addSubview:self.containerView];
		
		_stack = [[NSMutableArray alloc] initWithCapacity:0];
		//[_stack addObject:rootController];
		
		[self pushViewController:rootController];
		
		defaultBackButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"defaultBackButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popAnimated)];
		
		
	}
	return self;
	
}


-(void) makeDefaultBackButton
{
	
}

- (void) setRootController:(MatrixViewController*)rootController
{
	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       defaultBackButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"defaultBackButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popAnimated)];
    }
    return self;
}


-(void)pushViewController:(UIViewController*)viewController
{
	//CGRect theFrame = viewController.view.frame;
	//NSLog (@"rect of viewCOntroller %3.2f, %3.2f, %3.2f, %3.2f", theFrame.origin.x, theFrame.origin.y, theFrame.size.width, theFrame.size.height);
	[self.navigationBar pushNavigationItem:viewController.navigationItem animated:YES];
	[_stack addObject:viewController];
	
	
	
	if ([viewController respondsToSelector:NSSelectorFromString(@"matrixNavigationController")])
	{
		[viewController performSelector:@selector(setMatrixNavigationController:) withObject:self];
	}
	//theFrame = self.view.frame;
	//NSLog (@"rect of viewCOntroller %3.2f, %3.2f, %3.2f, %3.2f", theFrame.origin.x, theFrame.origin.y, theFrame.size.width, theFrame.size.height);
	[self.containerView addSubview:viewController.view];
}

-(void)popViewController
{
	UIViewController* topViewController = [self.stack lastObject];
	if (topViewController)
	{
		[topViewController.view removeFromSuperview];
		[self.stack removeLastObject];
		[self.navigationBar popNavigationItemAnimated:YES];
	}
}

-(void)pushViewController:(UIViewController*)viewController fromFrame:(CGRect)inFrame animated:(BOOL)animated
{
	CGRect  originalInputFrame = viewController.view.frame;
	
	[_stack addObject:viewController];
	viewController.view.clipsToBounds = YES;
	CGFloat xFactor = inFrame.size.width / viewController.view.frame.size.width;
	CGFloat yFactor = inFrame.size.height / viewController.view.frame.size.height;
	CGAffineTransform reduce = CGAffineTransformMakeScale(xFactor, yFactor);
	viewController.view.transform = reduce;
	
	viewController.view.frame = CGRectMake(inFrame.origin.x, inFrame.origin.y, viewController.view.frame.size.width, viewController.view.frame.size.height);
	
	
	CGAffineTransform enlarge = CGAffineTransformMakeScale(1, 1);
	//CGAffineTransform shift = CGAffineTransformMakeTranslation(viewController.view.frame.origin.x/2, viewController.view.frame.origin.y/2);
	
	if ([viewController respondsToSelector:NSSelectorFromString(@"matrixNavigationController")])
	{
		[viewController performSelector:@selector(setMatrixNavigationController:) withObject:self];
	}
	[self.containerView addSubview:viewController.view];
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
					 animations:^{viewController.view.transform = enlarge;viewController.view.frame = CGRectMake(0, 0, originalInputFrame.size.width, originalInputFrame.size.height);}
					 completion:^(BOOL finished){[self didPushViewController:viewController];}];
	
	//viewController.view.frame = self.view.frame;
	//[self.navigationBar popNavigationItemAnimated:YES];
	UIBarButtonItem *leftItem  = viewController.navigationItem.leftBarButtonItem;
	//	if (_stack.count == 1)
	//		[self.navigationBar pushNavigationItem:self.navigationItem animated:YES];
	if (leftItem)
	{
		//self.navigationItem.leftBarButtonItem = leftItem;
		//[self.navigationItem setLeftBarButtonItem:leftItem animated:YES];
		[self.navigationBar pushNavigationItem:viewController.navigationItem animated:YES];
		
		
	}
	else 
	{
		self.navigationItem.leftBarButtonItem = defaultBackButtonItem;
		NSMutableArray* itemArray = [NSMutableArray arrayWithArray:self.navigationBar.items];
		[itemArray addObject:self.navigationItem];
		
		[self.navigationBar setItems:itemArray];
		
	}
}


-(void)makeDefaultNavigationItemsForViewController:(UIViewController*)viewController
{
	UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 35)];
	titleView.font = [UIFont fontWithName:@"Helvetica" size:15];
	titleView.textColor = [UIColor whiteColor];
	titleView.backgroundColor = [UIColor clearColor];
	titleView.text = viewController.title;
	self.navigationItem.titleView = titleView;
	
	if (viewController.navigationItem.leftBarButtonItem)
	{
		self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem;
	}
	else
	{
		self.navigationItem.leftBarButtonItem = defaultBackButtonItem;
	}
	
	if (viewController.navigationItem.rightBarButtonItem)
	{
		self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem;
	}
}

-(void)makeDefaultNavigationItems2ForViewController:(UIViewController*)viewController
{
	UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 35)];
	titleView.font = [UIFont fontWithName:@"Helvetica" size:15];
	titleView.textColor = [UIColor whiteColor];
	titleView.backgroundColor = [UIColor clearColor];
	titleView.text = viewController.title;
	self.navigationItem.titleView = titleView;
	
	if (viewController.navigationItem.leftBarButtonItem)
	{
		self.navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem;
	}
	else
	{
		self.navigationItem.leftBarButtonItem = defaultBackButtonItem;
	}
	
	if (viewController.navigationItem.rightBarButtonItem)
	{
		self.navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem;
	}
}

-(void)pushModalViewController:(UIViewController*)viewController fromFrame:(CGRect)inFrame animated:(BOOL)animated
{
	CGRect  originalInputFrame = viewController.view.frame;
	
	[_stack addObject:viewController];
	viewController.view.clipsToBounds = YES;
	CGFloat xFactor = inFrame.size.width / viewController.view.frame.size.width;
	CGFloat yFactor = inFrame.size.height / viewController.view.frame.size.height;
	CGAffineTransform reduce = CGAffineTransformMakeScale(xFactor, yFactor);
	viewController.view.transform = reduce;
	
	viewController.view.frame = CGRectMake(inFrame.origin.x, inFrame.origin.y, viewController.view.frame.size.width, viewController.view.frame.size.height);
	
	
	CGAffineTransform enlarge = CGAffineTransformMakeScale(1, 1);
	//CGAffineTransform shift = CGAffineTransformMakeTranslation(viewController.view.frame.origin.x/2, viewController.view.frame.origin.y/2);
	
	if ([viewController respondsToSelector:NSSelectorFromString(@"matrixNavigationController")])
	{
		[viewController performSelector:@selector(setMatrixNavigationController:) withObject:self];
	}
	[self.containerView addSubview:viewController.view];
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
					 animations:^{viewController.view.transform = enlarge;viewController.view.frame = CGRectMake(0, 0, originalInputFrame.size.width, originalInputFrame.size.height);}
					 completion:^(BOOL finished){[self didPushViewController:viewController];}];
	
	//viewController.view.frame = self.view.frame;
	//[self.navigationBar popNavigationItemAnimated:YES];
//	UIBarButtonItem *leftItem  = viewController.navigationItem.leftBarButtonItem;
//	//	if (_stack.count == 1)
//	//		[self.navigationBar pushNavigationItem:self.navigationItem animated:YES];
//	if (leftItem)
//	{
//		//self.navigationItem.leftBarButtonItem = leftItem;
//		//[self.navigationItem setLeftBarButtonItem:leftItem animated:YES];
//		[self.navigationBar pushNavigationItem:viewController.navigationItem animated:YES];
//		
//		
//	}
//	else 
//	{
//		self.navigationItem.leftBarButtonItem = defaultBackButtonItem;
//		//[self.navigationBar pushNavigationItem:self.navigationItem animated:YES];
//		//[self.navigationItem setLeftBarButtonItem:defaultBackButtonItem animated:YES];
//		NSMutableArray* itemArray = [NSMutableArray arrayWithArray:self.navigationBar.items];
//		[itemArray addObject:self.navigationItem];
//		
//		[self.navigationBar setItems:itemArray];
//		
//	}
}


-(void)pushViewController:(UIViewController*)viewController fromCell:(MatrixCellView*)cell animated:(BOOL)animated
{
	[self pushViewController:viewController fromFrame:cell.frame animated:animated];
}

-(void)pushModalViewController:(UIViewController*)viewController fromCell:(MatrixCellView*)cell animated:(BOOL)animated
{
	[self pushModalViewController:viewController fromFrame:cell.frame animated:animated];
}



/*
-(void)pushViewController:(UIViewController*)viewController FromCell:(MatrixCellView*)cell animated:(BOOL)animated
{
	CGRect  originalInputFrame = viewController.view.frame;
	
	[_stack addObject:viewController];
	viewController.view.clipsToBounds = YES;
	CGFloat xFactor = cell.frame.size.width / viewController.view.frame.size.width;
	CGFloat yFactor = cell.frame.size.height / viewController.view.frame.size.height;
	CGAffineTransform reduce = CGAffineTransformMakeScale(xFactor, yFactor);
	viewController.view.transform = reduce;
	
	viewController.view.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, viewController.view.frame.size.width, viewController.view.frame.size.height);
	
	
	CGAffineTransform enlarge = CGAffineTransformMakeScale(1, 1);
	//CGAffineTransform shift = CGAffineTransformMakeTranslation(viewController.view.frame.origin.x/2, viewController.view.frame.origin.y/2);
	
	if ([viewController respondsToSelector:NSSelectorFromString(@"matrixNavigationController")])
	{
		[viewController performSelector:@selector(setMatrixNavigationController:) withObject:self];
	}
	[self.containerView addSubview:viewController.view];
	[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
					 animations:^{viewController.view.transform = enlarge;viewController.view.frame = CGRectMake(0, 0, originalInputFrame.size.width, originalInputFrame.size.height);}
					 completion:^(BOOL finished){[self didPushViewController:viewController];}];
	
	//viewController.view.frame = self.view.frame;
	//[self.navigationBar popNavigationItemAnimated:YES];
	UIBarButtonItem *leftItem  = viewController.navigationItem.leftBarButtonItem;
	//	if (_stack.count == 1)
	//		[self.navigationBar pushNavigationItem:self.navigationItem animated:YES];
	if (leftItem)
	{
		//self.navigationItem.leftBarButtonItem = leftItem;
		//[self.navigationItem setLeftBarButtonItem:leftItem animated:YES];
		[self.navigationBar pushNavigationItem:viewController.navigationItem animated:YES];
		
		
	}
	else 
	{
		self.navigationItem.leftBarButtonItem = defaultBackButtonItem;
		//[self.navigationBar pushNavigationItem:self.navigationItem animated:YES];
		//[self.navigationItem setLeftBarButtonItem:defaultBackButtonItem animated:YES];
		NSMutableArray* itemArray = [NSMutableArray arrayWithArray:self.navigationBar.items];
		[itemArray addObject:self.navigationItem];
		
		[self.navigationBar setItems:itemArray];
		
	}
}

*/
-(void)popAnimated
{
	[self popViewControllerAnimated:YES];
	//[self.navigationBar popNavigationItemAnimated:YES];
}

-(void)popViewControllerAnimated:(BOOL)animated
{
	if (animated==NO)
		[self popViewController];
	else 
	{
		UIViewController* topViewController = [self.stack lastObject];
		if (topViewController)
		{
			
			//CGFloat xFactor = 106 / topViewController.view.frame.size.width;
			//CGFloat yFactor = 106 / topViewController.view.frame.size.height;
			CGAffineTransform reduce = CGAffineTransformMakeScale(0.1, 0.1);

			[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionCurveEaseInOut 
							 animations:^{topViewController.view.transform = reduce;}
							 completion:^(BOOL finished){[self didPopViewController:topViewController];}];

			//[topViewController release];
			// remove with animation
			NSMutableArray* itemArray = [NSMutableArray arrayWithArray:self.navigationBar.items];
			[itemArray removeLastObject];
			
			[self.navigationBar setItems:itemArray];
			
		}
	}
	
}

-(void) didPushViewController:(UIViewController*)viewController
{
	
}

-(void) didPopViewController:(UIViewController*)viewController
{
	[viewController.view removeFromSuperview];
	[_stack removeLastObject];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.view.clipsToBounds = YES;
	CGRect containerRect = self.view.frame;
	root.view.frame = containerRect;
	[self.view addSubview:root.view];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	[self releaseOutlets];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) releaseOutlets
{
	if (_navigationBar) {
		[_navigationBar release];
	}
	
	if (_containerView)
	{
		[_containerView release];
	}
	
	if (_root)
	{
		[_root release];
	}
	
}

-(void) dealloc
{
	[super dealloc];
	if (_stack) {
		[_stack release];
	}
}
@end
