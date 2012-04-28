//
//  GraphView.m
//  Calculator
//
//  Created by Mark Lubin on 4/26/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

@synthesize dataSource = _dataSource;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)pan:(UIPanGestureRecognizer *)recognizer{
    //move origin with pan, maybe share code with tap:

}

-(void)tap:(UITapGestureRecognizer *)recognizer{
    //move origin for triple tap
}

-(void)pinch:(UIPinchGestureRecognizer *)recognizer{
    //scale when pinched
}

- (void)drawRect:(CGRect)rect
{
    double x = 0;
    double y = [self.dataSource functionValueAtPoint:x];
}
@end
