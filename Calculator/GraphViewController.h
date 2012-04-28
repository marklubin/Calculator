//
//  GraphViewController.h
//  Calculator
//
//  Created by Mark Lubin on 4/26/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"


@interface GraphViewController : 
    UIViewController<UISplitViewControllerDelegate,GraphDataSource>
@property (nonatomic,strong) id program;
@property (weak, nonatomic) IBOutlet GraphView *graph;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;


@end
