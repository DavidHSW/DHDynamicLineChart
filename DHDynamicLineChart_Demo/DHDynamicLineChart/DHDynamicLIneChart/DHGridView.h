//
//  DHGridView.h
//  DHDynamicLineChart
//
//  Created by David Hu on 12/27/16.
//  Copyright © 2016 David HU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DHGridView;

@protocol DHGridViewDelegate <NSObject>

- (void)didRedrawedGridView:(DHGridView *)grieView;

@end


@interface DHGridView : UIView

@property (nullable, nonatomic, weak) id<DHGridViewDelegate> delegate;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic) CGFloat yBase;
@property (nonatomic) CGFloat yRange;

- (instancetype)initWithDirectionUp:(BOOL)isUp;
- (void)refreshWithXLineNum:(NSUInteger)xLineNum YLineNum:(NSUInteger)yLineNum;

@end

NS_ASSUME_NONNULL_END
