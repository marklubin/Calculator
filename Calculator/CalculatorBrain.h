//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Mark Lubin
//  Copyright (c) 2012 Mark Lubin
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)op;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (NSSet *)supportedOperations;
-(void)clearOperandStack;
-(void)pushVariable:(NSString*) variable;
-(void)setValue:(double)value forVariable:(NSString *)variable;
-(void)removeLastItem;


@end
