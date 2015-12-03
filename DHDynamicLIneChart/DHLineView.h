//
//  DHLineView.h
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/12/2.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHLineView : UIView

@property (nonatomic)CGFloat lineWidth;
@property (nonatomic)UIColor *lineColor;

- (void)drawLineWithControlPoints:(NSArray *)controlPoints;

@end
