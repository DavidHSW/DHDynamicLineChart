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
        _isUp = isUp;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat xGridLineInterval = (width - _lineWidth) / _xLineNum;
    CGFloat yGridLineInterval = (height - _lineWidth) / _yLineNum;
    CGFloat gridOffset = _lineWidth / 2;

    _yRange = height - yGridLineInterval - _lineWidth;
    _yBase = _isUp ? height - gridOffset : height - yGridLineInterval;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    
    //Draw x grid lines
    for (int i = 0; i < _xLineNum; i++) {
        CGContextMoveToPoint(context, i * xGridLineInterval + gridOffset, 0);
        CGContextAddLineToPoint(context, i * xGridLineInterval + gridOffset, height);
        CGContextStrokePath(context);
    }
    
    //Draw y grid lines
    NSUInteger start = _isUp ? 1 : 0;
    for (int i = 0; i < _yLineNum; i++) {
        CGContextMoveToPoint(context, 0, (i + start) * yGridLineInterval + gridOffset);
        CGContextAddLineToPoint(context, width, (i + start) * yGridLineInterval + gridOffset);
        CGContextStrokePath(context);
    }
    
    if ([_delegate respondsToSelector:@selector(didRedrawGridView:)]) {
        [_delegate didRedrawGridView:self];
    }
}

- (void)refreshWithXLineNum:(NSUInteger)xLineNum YLineNum:(NSUInteger)yLineNum {
    _xLineNum = xLineNum;
    _yLineNum = yLineNum;
    [self setNeedsDisplay];
}

- (void)refreshWithDirectionUp:(BOOL)isUp {
    _isUp = isUp;
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
