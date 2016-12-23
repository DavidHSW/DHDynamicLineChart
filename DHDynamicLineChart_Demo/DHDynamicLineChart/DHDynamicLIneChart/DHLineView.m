//
//  DHLineView.m
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/12/2.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import "DHLineView.h"

@interface DHLineView()
{
    NSArray<DHControllPoint *> *_controlPoints;
}
@end

@implementation DHLineView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _lineWidth = 1.0;
        _lineColor = [UIColor redColor];
    }
    return self;
}

-(void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    if (_controlPoints.count < 1) {
        return;
    }
    
    //draw line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    for (int i = 0; i < _controlPoints.count - 1; i++) {
        CGPoint fromPoint = _controlPoints[i].position;
        CGPoint toPoint = _controlPoints[i + 1].position;
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
        CGContextStrokePath(context);
    }
}

- (void)drawLineWithControlPoints:(NSArray<DHControllPoint *> *)controlPoints {
    _controlPoints = controlPoints;
    [self setNeedsDisplay];
}

@end
