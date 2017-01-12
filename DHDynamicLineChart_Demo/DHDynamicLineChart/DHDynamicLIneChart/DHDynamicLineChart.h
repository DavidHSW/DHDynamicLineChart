//
//  DHDynamicLineChart.h
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/11/30.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DHDyanmicChartDirection) {
    DHDyanmicChartDirectionUp = 0,
    DHDyanmicChartDirectionDown
};

@interface DHDynamicLineChart : UIView

@property (nonatomic)CGFloat lineWidth;
@property (nonatomic)UIColor *lineColor;
@property (nonatomic)CGFloat gridLineWidth;
@property (nonatomic)UIColor *gridLineColor;

- (instancetype)initWithXAxisLabelTitles:(NSArray<NSString *> *)xLabelTitles
                        yAxisLabelTitles:(NSArray<NSString *> *)yLabelTitles
                  controlPointsByXRatios:(NSArray<NSNumber *> *)xRatios
                               direction:(DHDyanmicChartDirection)direction;

- (void)resetLine;

- (void)refreshLineChartWithYRatio:(CGFloat)yRatio atIndex:(NSInteger)index;

- (void)refreshLineChartWithYRatios:(NSArray<NSNumber *> *)yRatios;

- (void)updateWithXAxisLabelTitles:(NSArray<NSString *> *)xLabelTitles
                  YAxisLabelTitles:(NSArray<NSString *> *)yLabelTitles
            controlPointsByXRatios:(NSArray<NSNumber *> *)xRatios
                         direction:(DHDyanmicChartDirection)direction;

- (void)setControlPointsWithXRatios:(NSArray<NSNumber *> *)xRatios;

@end

NS_ASSUME_NONNULL_END
