//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Mark Lubin on 4/23/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *operandStackDisplay;

@end
