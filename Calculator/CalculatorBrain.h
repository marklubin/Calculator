//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Mark Lubin on 4/23/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
- (void) pushOperand: (double) operand;
- (double) performOperation:(NSString *) operation;
- (void) clearOperandStack;

@end
