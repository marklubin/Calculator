//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Mark Lubin
//  Copyright (c) 2011 Mark Lubin
//  All rights reserved.
//

#import "CalculatorBrain.h"
#include <math.h>

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableDictionary *variableDictionary;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize variableDictionary = _variableDictionary;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}
-(NSMutableDictionary *)variableDictionary{
    if(_variableDictionary == nil) _variableDictionary = [[NSMutableDictionary alloc] init];
    return _variableDictionary;
}
- (id)program
{
    return [self.programStack copy];
}
+ (NSString *)descriptionOfProgram:(id)program{
    NSMutableArray *stack;
    NSString *result;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    if(stack) {
        result = [CalculatorBrain popDescriptionOfProgram:stack
                                               withParens:NO];
        while([stack lastObject]){
            //if theres still stuff left on the stack we haven't evaled yet print comma-seperated
            result = [result stringByAppendingFormat:@",%@",
                      [CalculatorBrain popDescriptionOfProgram:stack withParens:NO]];
        }
    }    
    
    else result = @"";
    return result;
}


+ (NSString *)popDescriptionOfProgram:(NSMutableArray *)stack
                           withParens:(BOOL)shouldUseParens
{
    //if an downsteam operation needs to be in parens for our order of ops to be 
    //semanatically correct we set withParents
    NSString *result;
    if(!stack) return @"";
    id topOfStack = [stack lastObject];
    [stack removeLastObject];
    if([topOfStack isKindOfClass:[NSNumber class]]){
        NSNumber *number = topOfStack;
        result = [number stringValue];
    }
    else if([topOfStack isKindOfClass:[NSString class]]
            && [CalculatorBrain isOperation:topOfStack]){
        //this is an operation deal with it
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            NSString *firstOperand = [CalculatorBrain popDescriptionOfProgram:stack
                                                                   withParens:NO];
            NSString *secondOperand = [CalculatorBrain popDescriptionOfProgram:stack
                                                                    withParens:NO];
            if(shouldUseParens){
                result = [NSString stringWithFormat:@"(%@+%@)",secondOperand,firstOperand]; 
            }else{
                result = [NSString stringWithFormat:@"%@+%@",secondOperand,firstOperand]; 
            }
        }else if([operation isEqualToString:@"-"]){
            NSString *firstOperand = [CalculatorBrain popDescriptionOfProgram:stack
                                      withParens:NO];
            NSString *secondOperand = [CalculatorBrain popDescriptionOfProgram:stack
                                       withParens:NO];
            if(shouldUseParens){
                result = [NSString stringWithFormat:@"(%@-%@)",secondOperand,firstOperand]; 
            }else{
                result = [NSString stringWithFormat:@"%@-%@",secondOperand,firstOperand]; 
            }
        }else if([operation isEqualToString:@"/"]){
            NSString *firstOperand = [CalculatorBrain popDescriptionOfProgram:stack
                                      withParens:YES];
            NSString *secondOperand = [CalculatorBrain popDescriptionOfProgram:stack
                                       withParens:YES];
            result = [NSString stringWithFormat:@"%@/%@",secondOperand,firstOperand];
            
        }else if([operation isEqualToString:@"*"]){
            NSString *firstOperand = [CalculatorBrain popDescriptionOfProgram:stack
                                      withParens:YES];
            NSString *secondOperand = [CalculatorBrain popDescriptionOfProgram:stack
                                       withParens:YES];
            result = [NSString stringWithFormat:@"%@*%@",firstOperand,secondOperand];
            
        }else if([operation isEqualToString:@"sin"]){
             result = [NSString stringWithFormat:@"sin(%@)",
                       [CalculatorBrain popDescriptionOfProgram:stack
                        withParens:NO]];
            
        }else if([operation isEqualToString:@"cos"]){
            result = [NSString stringWithFormat:@"cos(%@)",
                      [CalculatorBrain popDescriptionOfProgram:stack
                       withParens:NO]];
            
        }else if([operation isEqualToString:@"sqrt"]){
            result = [NSString stringWithFormat:@"sqrt(%@)",
                      [CalculatorBrain popDescriptionOfProgram:stack
                       withParens:NO]];
            
        }else if([operation isEqualToString:@"pi"]){
            result = @"pi";
        }
        
    } else if([topOfStack isKindOfClass:[NSString class]]){
        //treat this like a variable and just return it
        result = topOfStack;
    } else{
        //we don't know what this is so return an empty string
        result = @"";
    }
    return result; 
}

-(void) setValue:(double)value forVariable:(NSString *)variable{
    NSNumber *numberObjWrapper = [NSNumber numberWithDouble:value];
    [self.variableDictionary setValue:numberObjWrapper forKey:variable]; 
    //will this overright existing keys?
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}
-(void)pushVariable:(NSString *)variable{
    [self.programStack addObject:variable];
}


- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program
                         usingVariableValues:self.variableDictionary];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;

    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
                     [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
                     [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        }else if([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffProgramStack:stack]);
        }else if([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffProgramStack:stack]);
        }else if([operation isEqualToString:@"sqrt"]){
            result = [self popOperandOffProgramStack:stack];
            if(result >= 0){
                result = sqrt(result);
            }
            else result = 0;
        }else if([operation isEqualToString:@"pi"]){
            result = M_PI;
        }
        
    }

    return result;
}

+ (double)runProgram:(id)program 
 usingVariableValues:(NSDictionary *)variableValues{
    //decode values and send to regular run program
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    //lets get the variables used in this program
   NSSet *varsUsed = [self variablesUsedInProgram:stack];
    
   for(int i=0; i < stack.count; i++){
       id object = [stack objectAtIndex:i];
       //check type
       if([object isKindOfClass:[NSString class]]){
           NSString *string = object;
           if([varsUsed containsObject:string]) {
               NSNumber *variableValue = [variableValues objectForKey:string];
               if(!variableValue) variableValue = [NSNumber numberWithDouble:0.0];
               [stack replaceObjectAtIndex:i withObject:variableValue];
           }
       }
   }
    return [self popOperandOffProgramStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program{
    NSMutableArray *stack;
    NSMutableSet *variables = [[NSMutableSet alloc] init ];
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    for (id object in stack) {
        if([object isKindOfClass:[NSString class]]){
            NSString *string = object;
            if(![self isOperation:string] && ![variables containsObject:string]){
                [variables addObject:string];
            }
        }
    }
    if([variables count] != 0){
        return (NSSet*)variables;
    }
    else return nil;
}
+ (NSSet *)supportedOperations{
    return [NSSet setWithObjects:@"+",@"-",@"/",@"*",@"sin",@"cos",@"pi",@"sqrt", nil];
}


+(BOOL) isOperation:(NSString *)string{
    return [[self supportedOperations] containsObject:string];
}

-(void) clearOperandStack{
    [self.programStack removeAllObjects];
}
-(void) removeLastItem{
    [self.programStack removeLastObject];
}
//deprecated with new variable features
+ (double)runProgram:(id)program 
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

@end
