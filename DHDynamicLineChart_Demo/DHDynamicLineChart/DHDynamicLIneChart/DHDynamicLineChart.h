//
//  DHDynamicLineChart.h
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/11/30.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DHDynamicLineChart : UIView

@property (nonatomic)CGFloat lineWidth;
@property (nonatomic)UIColor *lineColor;
@property (nonatomic)CGFloat gridLineWidth;
@property (nonatomic)UIColor *gridLineColor;

- (instancetype)initWithXAxisLabels:(NSArray<NSString *> *)xLabels
                        yAxisLabels:(NSArray<NSString *> *)yLabels
             controlPointsByXRatios:(NSArray<NSNumber *> *)xRatios;

- (void)resetLine;

- (void)refresh;

- (void)refreshLineChartWithYRatio:(CGFloat)yRatio atIndex:(NSInteger)index;

- (void)refreshLineChartWithYRatios:(NSArray<NSNumber *> *)yRatios;

- (void)updateWithXAxisLabels:(NSArray<NSString *> *)xLabels
                  YAxisLabels:(NSArray<NSString *> *)yLabels
       controlPointsByXRatios:(NSArray<NSNumber *> *)xRatios
          immediatelyRefresh:(BOOL)refresh;

- (void)setControlPointsWithXRatios:(NSArray<NSNumber *> *)xRatios;

@end

NS_ASSUME_NONNULL_END
