//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Mark Lubin on 4/23/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic) BOOL userIsINTheMiddleOfEnteringDecimal;
@property (nonatomic,strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize programDescriptionDisplay = _programDescriptionDisplay;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;
@synthesize userIsINTheMiddleOfEnteringDecimal = _userIsINTheMiddleOfEnteringDecimal;

-(CalculatorBrain *)brain{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = [sender currentTitle];
    if ([self userIsInTheMiddleOfEnteringNumber]) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else{
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //if this is the graph segue
      //send it my program
}


- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringNumber = NO;
    self.userIsINTheMiddleOfEnteringDecimal = NO;
    self.programDescriptionDisplay.text = 
    [CalculatorBrain descriptionOfProgram:[self.brain program]];
   
}


- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringNumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.programDescriptionDisplay.text = 
    [CalculatorBrain descriptionOfProgram:[self.brain program]];
    self.userIsInTheMiddleOfEnteringNumber = NO;
    self.userIsINTheMiddleOfEnteringDecimal = NO;
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.programDescriptionDisplay.text = @"";
    self.userIsInTheMiddleOfEnteringNumber = NO;
    self.userIsINTheMiddleOfEnteringDecimal = NO;
    [self.brain clearOperandStack];
    
}

- (IBAction)decimalPressed {
    //code to allow for decimal points in numbers
    if (!self.userIsINTheMiddleOfEnteringDecimal) {
        self.display.text = @"";
        self.userIsINTheMiddleOfEnteringDecimal = YES;
        if(!self.userIsInTheMiddleOfEnteringNumber){
            self.userIsInTheMiddleOfEnteringNumber = YES;
        }
        self.display.text = [self.display.text stringByAppendingString:@"."];
    }
}
- (IBAction)variablePressed:(UIButton *)sender {
    //push a variable to the stack
    //push whatever was already in the display to the stack
    NSString *variableName = sender.currentTitle;
    if(self.userIsInTheMiddleOfEnteringNumber) [self enterPressed];
    [self.brain pushVariable:variableName];
    variableName = [variableName stringByAppendingString:@" "];
    self.programDescriptionDisplay.text = 
        [CalculatorBrain descriptionOfProgram:[self.brain program]];

}
- (IBAction)testPressed:(UIButton *)sender {
    NSString *test = sender.currentTitle;
    double x,y,z;
    //change to real test values
    if([test isEqualToString:@"Test 1"]){
        x = -2;
        y = 2;
        z = 4;
    }
    else if([test isEqualToString:@"Test 2"]){
        x = 0;
        y = 0;
        z = 0;
    }
    else if([test isEqualToString:@"Test 3"]){
        x = 0;
        y = 0;
        z = 0;
    }
    //set values for variables
    [self.brain setValue:x forVariable:@"x"];
    [self.brain setValue:y forVariable:@"y"];
    [self.brain setValue:z forVariable:@"z"];
    
}


- (IBAction)undoPressed {
    if(self.userIsInTheMiddleOfEnteringNumber){
        //remove the last digit in display
        self.display.text = [self.display.text substringToIndex:
                             [self.display.text length] - 1];
        if([self.display.text isEqualToString:@""]){
            //if that clears the display then
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringNumber = NO;
            self.userIsINTheMiddleOfEnteringDecimal = NO;
        }
        
    }else{
        [self.brain removeLastItem];
        self.display.text = @"0";
        self.programDescriptionDisplay.text = 
        [CalculatorBrain descriptionOfProgram:[self.brain program]];
    }

}
- (IBAction)graphPressed {
    //for ipad if crash is pressed lets give our GraphViewController some Data
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (void)viewDidUnload {
    [self setProgramDescriptionDisplay:nil];
    [super viewDidUnload];
}
@end
