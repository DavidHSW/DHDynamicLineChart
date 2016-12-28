//
//  DHGridView.m
//  DHDynamicLineChart
//
//  Created by David Hu on 12/27/16.
//  Copyright © 2016 David HU. All rights reserved.
//

#import "DHGridView.h"

@interface DHGridView()
{
    NSUInteger _xLineNum;
    NSUInteger _yLineNum;
    CGFloat _chartOffset;
    BOOL _isUp;
}
@end

@implementation DHGridView

- (instancetype)initWithDirectionUp:(BOOL)isUp {
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.contentMode = UIViewContentModeRedraw;
        _xLineNum = 0;
        _yLineNum = 0;
        _lineColor = [UIColor whiteColor];
        _lineWidth = 1.0;
        _chartOffset = isUp ? -_lineWidth : _lineWidth;
        _isUp = isUp;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat xGridLineInterval = width / _xLineNum;
    CGFloat yGridLineInterval = height / _yLineNum;
    
    _yRange = height - yGridLineInterval - _lineWidth;
    _yBase = _isUp ? height - _lineWidth : height - yGridLineInterval;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    
    //draw x grid lines
    for (int i = 0; i < _xLineNum; i++) {
        CGContextMoveToPoint(context, i * xGridLineInterval + _lineWidth, 0);
        CGContextAddLineToPoint(context, i * xGridLineInterval + _lineWidth, height);
        CGContextStrokePath(context);
    }
    
    //draw y grid lines
    for (int i = 0; i < _yLineNum + 1; i++) {
        CGContextMoveToPoint(context, 0, i * yGridLineInterval + _chartOffset);
        CGContextAddLineToPoint(context, width, i * yGridLineInterval + _chartOffset);
        CGContextStrokePath(context);
    }
    
    if ([_delegate respondsToSelector:@selector(didRedrawedGridView:)]) {
        [_delegate didRedrawedGridView:self];
    }
}

- (void)refreshWithXLineNum:(NSUInteger)xLineNum YLineNum:(NSUInteger)yLineNum {
    _xLineNum = xLineNum;
    _yLineNum = yLineNum;
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

@end
