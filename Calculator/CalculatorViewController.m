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
@synthesize operandStackDisplay = _operandStackDisplay;
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

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringNumber = NO;
    self.userIsINTheMiddleOfEnteringDecimal = NO;
    self.operandStackDisplay.text = [self.operandStackDisplay.text stringByAppendingString:[self.display.text stringByAppendingString:@" "]];
}


- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringNumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.operandStackDisplay.text = [self.operandStackDisplay.text stringByAppendingString:[operation stringByAppendingString:@" "]];
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.operandStackDisplay.text = @"";
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


- (void)viewDidUnload {
    [self setOperandStackDisplay:nil];
    [super viewDidUnload];
}
@end
