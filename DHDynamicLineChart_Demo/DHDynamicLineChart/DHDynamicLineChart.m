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

@property(nonatomic)NSInteger xGridLineInterval;
@property(nonatomic)NSInteger yGridLineInterval;

@property(nonatomic)CGPoint leftTopOriginalPosition;
@property(nonatomic)CGPoint rightBottomOriginalPosition;

@property(strong,nonatomic)NSMutableArray *controlPoints;

@property(copy,nonatomic)NSArray *labelSource_x;
@property(copy,nonatomic)NSArray *labelSource_y;

@property(strong,nonatomic)DHLineView *lineView;
//@property(nonatomic, readwrite)NSRange xAxisRange;
//@property(nonatomic, readwrite)NSRange yAxisRange;

@end


@implementation DHDynamicLineChart

- (instancetype)initWithFrame:(CGRect)frame
{
    //Default labels and control positions
    return [self initWithFram:frame xAxisLabels:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"] yAxisLabels:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"] controlPointsXRatioValue:@[@0.125,@0.25,@0.375,@0.5]];
}

//Designated initializer (initialized by code)
- (instancetype)initWithFram:(CGRect)frame xAxisLabels:(NSArray *)xLabels yAxisLabels:(NSArray *)yLabels controlPointsXRatioValue:(NSArray *)ratioValues
{
    if (self = [super initWithFrame:frame]) {
        _lineView = [[DHLineView alloc] initWithFrame:self.frame];
        [self addSubview:_lineView];
        
        _controlPoints = [[NSMutableArray alloc] init];
        [self configureChartWithXAxisLabels:xLabels yAxisLabels:yLabels];
        [self setControlPointsWithXRatioValues:ratioValues];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self drawGridLines];
}

- (void)setLineColor:(UIColor *)lineColor
{
    self.lineView.lineColor = lineColor;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    self.lineView.lineWidth = lineWidth;
}

#pragma mark - Add labels
- (void)configureChartWithXAxisLabels:(NSArray *)xLabels yAxisLabels:(NSArray *)yLabels
{

    self.labelSource_x = xLabels;
    self.labelSource_y = yLabels;
    
    _leftTopOriginalPosition = CGPointMake(self.frame.size.width / 10, self.frame.size.width / 15);
    _rightBottomOriginalPosition = CGPointMake(self.frame.size.width - self.frame.size.width / 20, self.frame.size.height - self.frame.size.height / 20);
    
    _xGridLineInterval = (_rightBottomOriginalPosition.x - _leftTopOriginalPosition.x) / _labelSource_x.count;
    _yGridLineInterval = (_rightBottomOriginalPosition.y - _leftTopOriginalPosition.y) / _labelSource_y.count;
    
    //add labels for x axis
    for (int i = 0; i < _labelSource_x.count; i++) {
        [self addLabelInRect:CGRectMake(_leftTopOriginalPosition.x - _xGridLineInterval / 3 + i * _xGridLineInterval, _leftTopOriginalPosition.y / 4, _xGridLineInterval * 2 / 3, _leftTopOriginalPosition.y / 2) Text:_labelSource_x[i]];
    }
    
    //add labels for y axis
    for (int i = 0; i < _labelSource_y.count; i++) {
        [self addLabelInRect:CGRectMake(_leftTopOriginalPosition.x / 4, _leftTopOriginalPosition.y - _yGridLineInterval / 3 + i * _yGridLineInterval, _leftTopOriginalPosition.x / 2, _yGridLineInterval * 2 / 3) Text:_labelSource_y[i]];
    }

}

- (void)addLabelInRect:(CGRect)rect Text:(NSString *)labelText
{
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

#pragma mark - Draw grid lines
- (void)drawGridLines
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.frame);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    //draw x grid lines
    for (int i = 0; i < self.labelSource_x.count; i++) {
        CGContextMoveToPoint(context, self.leftTopOriginalPosition.x + i * self.xGridLineInterval, self.leftTopOriginalPosition.y);
        CGContextAddLineToPoint(context, self.leftTopOriginalPosition.x + i * self.xGridLineInterval, self.rightBottomOriginalPosition.y);
        CGContextStrokePath(context);
    }
    //draw y grid lines
    for (int i = 0; i < self.labelSource_y.count; i++) {
        CGContextMoveToPoint(context, self.leftTopOriginalPosition.x, self.leftTopOriginalPosition.y + i * self.yGridLineInterval);
        CGContextAddLineToPoint(context, self.rightBottomOriginalPosition.x, self.leftTopOriginalPosition.y + i * self.yGridLineInterval);
        CGContextStrokePath(context);
    }
}

#pragma mark - Update labels
-(void)updateLabelsOfXAxis:(NSArray *)xLabels YAxis:(NSArray *)yLabels
{
    [self removeAllLabels];
    [self configureChartWithXAxisLabels:xLabels yAxisLabels:yLabels];
    [self setNeedsDisplay];
}

- (void)removeAllLabels
{
    for(UIView *subV in [self subviews])
    {
        if (![subV isKindOfClass:[DHLineView class]]) {
            [subV removeFromSuperview];
        }
    }
}

#pragma mark - Refresh line value
- (void)refreshLineChartWithYValue:(CGFloat)yValue atIndex:(NSInteger)index
{
    CGPoint point;
    [(NSValue *)self.controlPoints[index] getValue:&point];
    point.y = self.rightBottomOriginalPosition.y - yValue;
    self.controlPoints[index] = [NSValue valueWithCGPoint:point];
    [self.lineView drawLineWithControlPoints:self.controlPoints];
}

#pragma mark - Set control points
- (void)setControlPointsWithXRatioValues:(NSArray *)ratioValues
{
    for(NSNumber *value in ratioValues)
    {
        CGFloat temp = value.floatValue;
        if (temp > 1) {
            temp = 1.0;
        }else if(temp < 0)
        {
            temp = 0;
        }
        [self addControlPointWithXRatioValue:temp];
    }
}

- (void)addControlPointWithXRatioValue:(CGFloat)ratioValue
{
    CGFloat newPosition = ratioValue * (self.rightBottomOriginalPosition.x - self.leftTopOriginalPosition.x - self.xGridLineInterval) + self.leftTopOriginalPosition.x;
    
    if (self.controlPoints.count == 0) {
        [self.controlPoints addObject:[NSValue valueWithCGPoint:CGPointMake(newPosition, self.rightBottomOriginalPosition.y)]];
        return;
    }
    
    for (int i = 0; i < self.controlPoints.count; i++)
    {
        NSValue *value = (NSValue *)self.controlPoints[i];
        CGPoint point;
        [value getValue:&point];
        
        if (point.x > newPosition) {
            [self.controlPoints insertObject:[NSValue valueWithCGPoint:CGPointMake(newPosition, self.rightBottomOriginalPosition.y)] atIndex:i];
            break;
        }else if(point.x == newPosition)
        {
            break;
        }
        
        if(i == (self.controlPoints.count - 1))
        {
            [self.controlPoints addObject:[NSValue valueWithCGPoint:CGPointMake(newPosition, self.rightBottomOriginalPosition.y)]];
        }
    }
}

@end
