//
//  MatrixPosition.m
//  StackOView
//
//  Created by Daniel Arnaud on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MatrixPosition.h"

@implementation MatrixPosition

@synthesize row = _row;
@synthesize col = _col;

-(id) initWithRow:(NSUInteger)row column:(NSUInteger)column
{
	if (self = [super init])
	{
		self.row = row;
		self.col = column;
	}
	return self;
}

+(id) positionWithRow:(NSUInteger)row column:(NSUInteger)column
{
	MatrixPosition* position = [[[self alloc] initWithRow:row column:column] autorelease];
	
	return position;
}

@end
