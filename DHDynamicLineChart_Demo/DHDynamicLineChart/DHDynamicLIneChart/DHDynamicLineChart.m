//
//  DHDynamicLineChart.m
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/11/30.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import "DHDynamicLineChart.h"
#import "DHLineView.h"

@interface DHDynamicLineChart()
{
    NSInteger _xGridLineInterval;
    NSInteger _yGridLineInterval;
    
    CGPoint _leftTopOriginalPosition;
    CGPoint _rightBottomOriginalPosition;
    CGFloat _yAxisStartPosition;
    
    NSMutableArray *_controlPoints;
    NSArray *_xRatios;
    
    NSArray *_labelSource_x;
    NSArray *_labelSource_y;
    
    DHLineView *_lineView;
}
@end


@implementation DHDynamicLineChart

- (instancetype)init {
    
    //Default labels and control positions
    return [self initWithXAxisLabels:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]
                         yAxisLabels:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]
               controlPointsByXRatios:@[@0.125,@0.25,@0.375,@0.5]];
}

//Designated initializer.
- (instancetype)initWithXAxisLabels:(NSArray *)xLabels yAxisLabels:(NSArray *)yLabels controlPointsByXRatios:(NSArray *)xRatios {

    if (self = [super init]) {
        
        _labelSource_x = xLabels;
        _labelSource_y = yLabels;
        _xRatios = xRatios;
        
        _lineView = [[DHLineView alloc] init];
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_lineView];
        
        //Default setting.
        self.backgroundColor = [UIColor blackColor];
        _lineWidth = 1.0f;
        _gridLineWidth = 1.0f;
        _lineColor = [UIColor whiteColor];
        _gridLineColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [self removeAllLabels];
    [self configureChartWithXAxisLabels:_labelSource_x yAxisLabels:_labelSource_y inRect:rect];
    [self setControlPointsWithXRatios:_xRatios];
    [self drawGridLinesWithRect:rect];
}

- (void)configureChartWithXAxisLabels:(NSArray *)xLabels yAxisLabels:(NSArray *)yLabels inRect:(CGRect)rect{

    _leftTopOriginalPosition = CGPointMake(rect.size.width / 10, rect.size.width / 15);
    _rightBottomOriginalPosition = CGPointMake(rect.size.width - rect.size.width / 20, rect.size.height - rect.size.height / 20);

    _xGridLineInterval = (_rightBottomOriginalPosition.x - _leftTopOriginalPosition.x) / _labelSource_x.count;
    _yGridLineInterval = (_rightBottomOriginalPosition.y - _leftTopOriginalPosition.y) / _labelSource_y.count;

    _yAxisStartPosition = _yGridLineInterval * (_labelSource_y.count - 1) + _leftTopOriginalPosition.y;
    
    //add labels for x axis
    for (int i = 0; i < _labelSource_x.count; i++) {
        [self addLabelInRect:CGRectMake(_leftTopOriginalPosition.x - _xGridLineInterval / 3 + i * _xGridLineInterval, _leftTopOriginalPosition.y / 4, _xGridLineInterval * 2 / 3, _leftTopOriginalPosition.y / 2) Text:_labelSource_x[i]];
    }

    //add labels for y axis
    for (int i = 0; i < _labelSource_y.count; i++) {
        [self addLabelInRect:CGRectMake(_leftTopOriginalPosition.x / 4, _leftTopOriginalPosition.y - _yGridLineInterval / 3 + i * _yGridLineInterval, _leftTopOriginalPosition.x / 2, _yGridLineInterval * 2 / 3) Text:_labelSource_y[i]];
    }
}

- (void)addLabelInRect:(CGRect)rect Text:(NSString *)labelText {
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = labelText;

    NSInteger largestSize = 20;
    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:largestSize]}];
    while (size.width > rect.size.width * 4 / 5 || size.height > rect.size.height * 4 / 5) {
        largestSize--;
        size = [label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:largestSize]}];
    }
    label.font = [UIFont systemFontOfSize:largestSize];

    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
}

- (void)drawGridLinesWithRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, _gridLineWidth);
    CGContextSetStrokeColorWithColor(context, _gridLineColor.CGColor);

    //draw x grid lines
    for (int i = 0; i < _labelSource_x.count; i++) {
        CGContextMoveToPoint(context, _leftTopOriginalPosition.x + i * _xGridLineInterval, _leftTopOriginalPosition.y);
        CGContextAddLineToPoint(context, _leftTopOriginalPosition.x + i * _xGridLineInterval, _rightBottomOriginalPosition.y);
        CGContextStrokePath(context);
    }
    //draw y grid lines
    for (int i = 0; i < _labelSource_y.count; i++) {
        CGContextMoveToPoint(context, _leftTopOriginalPosition.x, _leftTopOriginalPosition.y + i * _yGridLineInterval);
        CGContextAddLineToPoint(context, _rightBottomOriginalPosition.x, _leftTopOriginalPosition.y + i * _yGridLineInterval);
        CGContextStrokePath(context);
    }
}

- (void)removeAllLabels {
    
    for(UIView *subV in [self subviews])
    {
        if (![subV isKindOfClass:[DHLineView class]]) {
            [subV removeFromSuperview];
        }
    }
}

#pragma mark - API

- (void)setLineColor:(UIColor *)lineColor {
    
    _lineView.lineColor = lineColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    
    _lineView.lineWidth = lineWidth;
}

- (void)refreshLineChartWithYRatio:(CGFloat)yRatio atIndex:(NSInteger)index {
    
    if (yRatio > 1) {
        yRatio = 1;
    }else if(yRatio < 0){
        yRatio = 0;
    }
    
    CGPoint point;
    [(NSValue *)_controlPoints[index] getValue:&point];
    point.y = _yAxisStartPosition - (_yAxisStartPosition - _leftTopOriginalPosition.y) * yRatio;
    _controlPoints[index] = [NSValue valueWithCGPoint:point];
    
    [_lineView drawLineWithControlPoints:_controlPoints];
}

- (void)refreshLineChartWithYRatios:(NSArray *)yRatios {

    NSUInteger loopCount = MIN(yRatios.count, _controlPoints.count);
    
    for (int i = 0; i < loopCount; i++) {
        [self refreshLineChartWithYRatio:((NSNumber *)yRatios[i]).floatValue atIndex:i];
    }
}

- (void)updateWithXAxisLabels:(NSArray *)xLabels YAxisLabels:(NSArray *)yLabels controlPointsByXRatios:(NSArray *)ratios {

    _labelSource_x = xLabels;
    _labelSource_y = yLabels;
    [self setControlPointsWithXRatios:ratios];
    
    [self setNeedsDisplay];
}

- (void)setControlPointsWithXRatios:(NSArray *)ratios {

    if (!ratios) return;
    if (!_controlPoints) { _controlPoints = [[NSMutableArray alloc] init]; }
    
    _xRatios = ratios;
    [_controlPoints removeAllObjects];
    CGFloat chartWidth = _xGridLineInterval * _labelSource_x.count;
    [ratios sortedArrayUsingSelector:@selector(compare:)];
    for(NSNumber *value in ratios)
    {
        CGFloat ratio = value.floatValue;
        if (ratio > 1) {
            ratio = 1.0;
        }
        else if(ratio < 0) {
            ratio = 0.0;
        }
        CGFloat newPosition = ratio * chartWidth + _leftTopOriginalPosition.x;
        [_controlPoints addObject:[NSValue valueWithCGPoint:CGPointMake(newPosition, _yAxisStartPosition)]];
    }
}

@end
