//
//  DHDynamicLineChart.h
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/11/30.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DHDynamicLineChartDataSource <NSObject>

@end

@interface DHDynamicLineChart : UIView

@property(weak,nonatomic)id<DHDynamicLineChartDataSource> delegate;
//@property(nonatomic, readonly)NSRange xAxisRange;
//@property(nonatomic, readonly)NSRange yAxisRange;
@property (nonatomic)CGFloat lineWidth;
@property (nonatomic)UIColor *lineColor;

- (instancetype)initWithFram:(CGRect)frame xAxisLabels:(NSArray *)xLabels yAxisLabels:(NSArray *)yLabels controlPointsXRatioValue:(NSArray *)ratioValues;

- (void)refreshLineChartWithYValue:(CGFloat)yValue atIndex:(NSInteger)index;

- (void)updateLabelsOfXAxis:(NSArray *)xLabels YAxis:(NSArray *)yLabels;

- (void)setControlPointsWithXRatioValues:(NSArray *)ratioValues;

- (void)addControlPointWithXRatioValue:(CGFloat)ratioValue;

@end
