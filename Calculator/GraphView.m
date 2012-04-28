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
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
@end

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize origin = _origin;
@synthesize scale = _scale;

-(void)setup{
    CGFloat x0 = self.frame.size.width/2.0;
    CGFloat y0 = self.frame.size.height/2.0;
    CGPoint initOrigin = CGPointMake(x0, y0);
    self.origin = initOrigin;
    //set initial scale
}
-(void)awakeFromNib{
    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
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
        

        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [AxesDrawer drawAxesInRect:self.bounds 
                 originAtPoint:self.origin 
                         scale:self.contentScaleFactor];
    //TODO Draw function for points x
    double x = 0;
    double y = [self.dataSource functionValueAtPoint:x];
}
@end
