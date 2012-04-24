//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Mark Lubin on 4/23/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import "CalculatorBrain.h"
#include <math.h>


@interface CalculatorBrain()

@property (nonatomic,strong) NSMutableArray *operandStack;

@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

-(NSMutableArray *) operandStack {
    if(!_operandStack) _operandStack = [[NSMutableArray alloc] init] ;
    return _operandStack;
}


- (void) pushOperand: (double) operand{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
    
}

-(double) popOperand{
    NSNumber *operandObj =  [self.operandStack lastObject];
    if(operandObj) [self.operandStack removeLastObject];
    return[operandObj doubleValue];
}

- (double) performOperation:(NSString *) operation{
    double result = 0;
    
    if([operation isEqualToString:@"+"]){
        result = [self popOperand] + [self popOperand];
    }
    else if([operation isEqualToString:@"-"]){
        double operand = [self popOperand];
        result = [self popOperand] - operand;
    }
    else if([operation isEqualToString:@"/"]){
        double operand = [self popOperand];
        if(operand) result = [self popOperand] / operand;
    }
    else if([operation isEqualToString:@"*"]){
        result = [self popOperand] * [self popOperand];
    }
    else if([operation isEqualToString:@"sin"]){
        result = sin([self popOperand]);
    }
    else if([operation isEqualToString:@"cos"]){
        result = cos([self popOperand]); //implement cos code
    }
    else if([operation isEqualToString:@"pi"]){
        result = M_PI ;//implement pi code;
    }
    else if([operation isEqualToString:@"sqrt"]){
        double num = [self popOperand];
        if(num >= 0) result = sqrt(num);
    }
    [self pushOperand:result];
    return result;
    
}
- (void) clearOperandStack{
    [self.operandStack removeAllObjects];
}

@end
