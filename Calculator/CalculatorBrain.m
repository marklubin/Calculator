//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
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

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
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
 usingVariableValues:(NSMutableDictionary *)variableValues{
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
               [stack replaceObjectAtIndex:i withObject:variableValue];
           }
       }
   }
    return [self popOperandOffProgramStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program{
    //loop through add all non-operations to NSSet use isOperation
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    for (id object in stack) {
        if([object isKindOfClass:[NSString class]]){
            NSString *string = object;
            if(![self isOperation:string]){
                //add this to variable list if its not there yet
            }
        }
    }
    return nil;
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
