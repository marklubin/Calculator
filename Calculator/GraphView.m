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
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;
@end

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize origin = _origin;
@synthesize scale = _scale;
@synthesize haveFunctionToGraph = _haveFunctionToGraph;



-(CGPoint)origin{
    if(_origin.x == 0.0 && _origin.y == 0){
        CGFloat x0 = self.bounds.size.width/2.0;
        CGFloat y0 = self.bounds.size.height/2.0;
        CGPoint initOrigin = CGPointMake(x0, y0);
        _origin = initOrigin; 
    }
    return _origin;
}

-(CGFloat)scale{
    if(_scale == 0.0){
        _scale = 20.0;
    }
    return _scale;
}


-(void)pan:(UIPanGestureRecognizer *)recognizer{
    //move origin with pan, maybe share code with tap:
    if((recognizer.state == UIGestureRecognizerStateChanged)||
       (recognizer.state == UIGestureRecognizerStateEnded))
    {
        CGPoint translation = [recognizer translationInView:self];
        self.origin = CGPointMake(self.origin.x+translation.x, 
                                  self.origin.y+translation.y);
        
        [recognizer setTranslation:CGPointZero inView:self];
        [self setNeedsDisplay];
    }
  

}

-(void)tap:(UITapGestureRecognizer *)recognizer{
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        self.origin = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
}

-(void)pinch:(UIPinchGestureRecognizer *)recognizer{
    if((recognizer.state == UIGestureRecognizerStateChanged)||
       (recognizer.state == UIGestureRecognizerStateEnded))
    {
        
        //self.scale *= (recognizer.scale/10);
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [AxesDrawer drawAxesInRect:self.bounds 
                 originAtPoint:self.origin 
                         scale:self.scale];
    //TODO Draw function for points x
    if(self.haveFunctionToGraph){
        CGFloat cursor = 0.0;
        CGFloat x,y,height;
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, cursor, self.origin.y);
        while(cursor < self.bounds.size.width){
            x = (cursor - self.origin.x)/self.scale;
            y = [self.dataSource functionValueAtPoint:x];
            height = (self.origin.y - (y * self.scale));
            CGContextAddLineToPoint(context, cursor, height);
            cursor += self.contentScaleFactor;
        }
        [[UIColor redColor] setStroke];
        CGContextDrawPath(context, kCGPathStroke);
    }
    
}
@end
