//
//  GraphView.m
//  Calculator
//
//  Created by Mark Lubin on 4/26/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView()
@property CGPoint origin;
@property double scale;
@end

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize origin = _origin;
@synthesize scale = _scale;





-(void)pan:(UIPanGestureRecognizer *)recognizer{
    //move origin with pan, maybe share code with tap:
    [self setNeedsDisplay];

}

-(void)tap:(UITapGestureRecognizer *)recognizer{
    //move origin for triple tap
    [self setNeedsDisplay];
}

-(void)pinch:(UIPinchGestureRecognizer *)recognizer{
    //scale when pinched
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
  /*  [AxesDrawer drawAxesInRect:<#(CGRect)#> originAtPoint:<#(CGPoint)#> scale:<#(CGFloat)#>]; */
    double x = 0;
    double y = [self.dataSource functionValueAtPoint:x];
}
@end
