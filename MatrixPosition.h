//
//  MatrixPosition.h
//  StackOView
//
//  Created by Daniel Arnaud on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatrixPosition : NSObject

@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger col;

-(id) initWithRow:(NSUInteger)row column:(NSUInteger)column;
+(id) positionWithRow:(NSUInteger)row column:(NSUInteger)column;

@end
