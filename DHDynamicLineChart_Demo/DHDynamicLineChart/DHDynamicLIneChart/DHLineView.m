//
//  DHLineView.m
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/12/2.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import "DHLineView.h"

@interface DHLineView()

@property(copy,nonatomic)NSArray *controlPoints;

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
    if (self.controlPoints.count < 1) {
        return;
    }
    
    //draw line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    for (int i = 0; i < self.controlPoints.count - 1; i++) {
        CGPoint fromPoint;
        CGPoint toPoint;
        [(NSValue *)self.controlPoints[i] getValue:&fromPoint];
        [(NSValue *)self.controlPoints[i+1] getValue:&toPoint];
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y);
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y);
        CGContextStrokePath(context);
    }

}

-(void)drawLineWithControlPoints:(NSArray *)controlPoints
{
    self.controlPoints = controlPoints;
    [self setNeedsDisplay];
}

@end
