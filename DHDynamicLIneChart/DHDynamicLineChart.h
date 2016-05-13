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
@property (strong,nonatomic)UIColor *bgColor;

- (instancetype)initWithFram:(CGRect)frame xAxisLabels:(NSArray *)xLabels yAxisLabels:(NSArray *)yLabels controlPointsXRatioValue:(NSArray *)ratioValues;

- (void)refreshLineChartWithYValue:(CGFloat)yValue atIndex:(NSInteger)index;

-(void)refreshLineChartWithYValues:(NSArray *)yValues;

- (void)refreshLineChartForSlider:(UISlider *)slider;

- (void)updateLabelsOfXAxis:(NSArray *)xLabels YAxis:(NSArray *)yLabels;

- (void)setControlPointsWithXRatioValues:(NSArray *)ratioValues;

- (void)addControlPointWithXRatioValue:(CGFloat)ratioValue;

@end
