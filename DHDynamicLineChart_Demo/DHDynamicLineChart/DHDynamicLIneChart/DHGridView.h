//
//  DHGridView.h
//  DHDynamicLineChart
//
//  Created by David Hu on 12/27/16.
//  Copyright © 2016 David HU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHGridView : UIView

@property (nonatomic) CGFloat lineWidth;
@property (nonnull, nonatomic, strong) UIColor *lineColor;

@property (nonatomic) CGFloat yBase;
@property (nonatomic) CGFloat yRange;

- (instancetype)initWithDirectionUp:(BOOL)isUp;
- (void)refreshWithXLineNum:(NSUInteger)xLineNum YLineNum:(NSUInteger)yLineNum;

@end
