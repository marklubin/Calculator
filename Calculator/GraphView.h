//
//  GraphView.h
//  Calculator
//
//  Created by Mark Lubin on 4/26/12.
//  Copyright (c) 2012 Lubin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GraphDataSource
-(double)functionValueAtPoint:(double)x;
@end



@interface GraphView : UIView

@property id<GraphDataSource> dataSource;

@end
