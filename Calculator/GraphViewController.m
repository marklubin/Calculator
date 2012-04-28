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

-(double)functionValueAtPoint:(double)x{
    double result = 0;
    //call calculator brain with function value of x and return result
   /* NSDIctionary *variable = [NSDictionary dictionaryWithObject:<#(id)#> forKey:<#(id)#>*/
    return result;
}

-(void)setProgram:(id)program{
    _program = program;
    //when my program changes lets set my title
    self.title  = [CalculatorBrain descriptionOfProgram:self.program];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (self.splitViewController) return YES;
    else return interfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
