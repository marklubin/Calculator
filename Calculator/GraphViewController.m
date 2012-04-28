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

@end

@implementation GraphViewController
@synthesize program = _program;
@synthesize graph = _graph;
@synthesize toolBar = _toolBar;

-(void)setGraph:(GraphView *)graph{
    _graph = graph;
    //add gesture recs
    UIPanGestureRecognizer *pangr = 
    [[UIPanGestureRecognizer alloc] initWithTarget:self.graph action:@selector(pan:)];
    UIPinchGestureRecognizer *pinchgr = 
    [[UIPinchGestureRecognizer alloc] initWithTarget:self.graph action:@selector(pinch:)];
    UITapGestureRecognizer *tapgr = 
    [[UITapGestureRecognizer alloc] initWithTarget:self.graph action:@selector(tap:)];
    [self.graph addGestureRecognizer:pangr];
    [self.graph addGestureRecognizer:pinchgr];
    [self.graph addGestureRecognizer:tapgr];
}

-(double)functionValueAtPoint:(double)x{
    double result = 0;
    //call calculator brain with function value of x and return result
   /* NSDIctionary *variable = [NSDictionary dictionaryWithObject:<#(id)#> forKey:<#(id)#>*/
    return result;
}

-(void)setProgram:(id)program{
    _program = program;
    //when my program changes lets set my title this shows on the iphone
    self.title  = [CalculatorBrain descriptionOfProgram:self.program];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.splitViewController.delegate = self;
	self.graph.dataSource = self; //set myself as the GraphView's DataSource
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
