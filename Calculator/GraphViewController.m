//
//  GraphViewController.m
//  Calculator
//
//  Created by Mark Lubin on 4/26/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"

@interface GraphViewController ()
@property BOOL haveFunctionToGraph;

@end

@implementation GraphViewController
@synthesize program = _program;
@synthesize graph = _graph;
@synthesize toolBar = _toolBar;
@synthesize haveFunctionToGraph = _haveFunctionToGraph;

-(void)setGraph:(GraphView *)graph{
    _graph = graph;
    //add gesture recs
    UIPanGestureRecognizer *pangr = 
    [[UIPanGestureRecognizer alloc] initWithTarget:self.graph action:@selector(pan:)];
    UIPinchGestureRecognizer *pinchgr = 
    [[UIPinchGestureRecognizer alloc] initWithTarget:self.graph action:@selector(pinch:)];
    UITapGestureRecognizer *tapgr = 
    [[UITapGestureRecognizer alloc] initWithTarget:self.graph action:@selector(tap:)];
    tapgr.numberOfTapsRequired = 3;
    [self.graph addGestureRecognizer:pangr];
    [self.graph addGestureRecognizer:pinchgr];
    [self.graph addGestureRecognizer:tapgr];
}


-(double)functionValueAtPoint:(double)x{
    double result = 0;
    NSNumber *numberWrapper = [NSNumber numberWithDouble:x];
    NSDictionary *variable = [NSDictionary dictionaryWithObject:numberWrapper forKey:@"x"];
    result = [CalculatorBrain runProgram:self.program usingVariableValues:variable];
    return result;
}

-(void)setProgram:(id)program{
    _program = program;
    //when my program changes lets set my title this shows on the iphone
    self.title  = [CalculatorBrain descriptionOfProgram:self.program];
    if(self.graph){ //ipad
        self.graph.haveFunctionToGraph = YES;
        [self.graph setNeedsDisplay];
    }
    //if i'm on the iphone ill tell myself i have something to graph when the view loads
    self.haveFunctionToGraph = YES; 
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.splitViewController.delegate = self;
    self.splitViewController.presentsWithGesture = NO;
	self.graph.dataSource = self; //set myself as the GraphView's DataSource
    if(self.haveFunctionToGraph){//iphone
        self.graph.haveFunctionToGraph = YES;
        [self.graph setNeedsDisplay];
    }
}

- (void)viewDidUnload
{
    [self setGraph:nil];
    [self setToolBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
    barButtonItem.title = @"RPN Calculator";
    [toolbarItems insertObject:barButtonItem atIndex:0];
    self.toolBar.items = toolbarItems;
   
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
    [toolbarItems removeObject:barButtonItem];
    self.toolBar.items = toolbarItems;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (self.splitViewController) return YES;
    else return interfaceOrientation == UIInterfaceOrientationPortrait;
}


@end
