//
//  DHDynamicLineChart.h
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/11/30.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DHDynamicLineChart;

typedef NS_ENUM(NSInteger, DHDyanmicChartDirection) {
    DHDyanmicChartDirectionUp = 0,
    DHDyanmicChartDirectionDown
};

typedef void(^completionBlock)(DHDynamicLineChart *chart);

@interface DHDynamicLineChart : UIView

@property (nonatomic)CGFloat lineWidth;
@property (nonatomic)UIColor *lineColor;
@property (nonatomic)CGFloat gridLineWidth;
@property (nonatomic)UIColor *gridLineColor;

/**
 Designated initializer.

 @param xLabelTitles The label titles for x axis.
 @param yLabelTitles The label titles for y axis.
 @param xRatios The positions(by ratio:[1,0]) you want to control. 
                If nil, take default position: For every x label, there will ba a control point at its x position.
                You may also set any ratio to specify any position you want to control regardless of x labels' location.
 @param direction Facing up or facing down.
 @return Object of DHDynamicLineChart.
 */
- (instancetype)initWithXAxisLabelTitles:(NSArray<NSString *> *)xLabelTitles
                        yAxisLabelTitles:(NSArray<NSString *> *)yLabelTitles
                  controlPointsByXRatios:(nullable NSArray<NSNumber *> *)xRatios
                               direction:(DHDyanmicChartDirection)direction;

#pragma mark - Change y values.

/**
 Reset line to minimal y.
 */
- (void)resetLine;

/**
 Set y value at certain index.

 @param yRatio Ratio value of y axis([0,1]).
 @param index The index of control point you want to set.
 */
- (void)refreshLineChartWithYRatio:(CGFloat)yRatio atIndex:(NSInteger)index;

/**
 Set y values with array.

 @param yRatios Array of y values. If the count of array is more than the count of control point, extra y value will not be used. If less, extra points will not be updated.
 */
- (void)refreshLineChartWithYRatios:(NSArray<NSNumber *> *)yRatios;

#pragma mark - Update chart components.

- (void)updateWithXAxisLabelTitles:(NSArray<NSString *> *)xLabelTitles;

- (void)updateWithYAxisLabelTitles:(NSArray<NSString *> *)yLabelTitles;

- (void)updateWithControlPointsByXRatios:(nullable NSArray<NSNumber *> *)xRatios;

- (void)updateWithDirection:(DHDyanmicChartDirection)direction
                   animated:(BOOL)animated
                 completion:(nullable completionBlock)completion;

- (void)switchDirectionAnimated:(BOOL)animated
                     completion:(nullable completionBlock)completion;

- (void)updateWithXAxisLabelTitles:(NSArray<NSString *> *)xLabelTitles
                  YAxisLabelTitles:(NSArray<NSString *> *)yLabelTitles
            controlPointsByXRatios:(nullable NSArray<NSNumber *> *)xRatios
                         direction:(DHDyanmicChartDirection)direction
                          animated:(BOOL)animated
                        completion:(nullable completionBlock)completion;

@end

NS_ASSUME_NONNULL_END
