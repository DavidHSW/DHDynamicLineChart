//
//  DHDynamicLineChart.h
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/11/30.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHDynamicLineChart : UIView

@property (nonatomic)CGFloat lineWidth;
@property (nonatomic)UIColor *lineColor;
@property (nonatomic)CGFloat gridLineWidth;
@property (nonatomic)UIColor *gridLineColor;

@property (nonatomic)CGFloat yMax;

- (instancetype)initWithXAxisLabels:(NSArray *)xLabels yAxisLabels:(NSArray *)yLabels controlPointsByXRatios:(NSArray *)xRatios;

- (void)refreshLineChartWithYRatio:(CGFloat)yRatio atIndex:(NSInteger)index;

- (void)refreshLineChartWithYRatios:(NSArray *)yRatios;

- (void)updateWithXAxisLabels:(NSArray *)xLabels YAxisLabels:(NSArray *)yLabels controlPointsByXRatios:(NSArray *)ratios;

- (void)setControlPointsWithXRatios:(NSArray *)ratios;

@end
