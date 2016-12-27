//
//  DHDynamicLineChart.m
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/11/30.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import "DHDynamicLineChart.h"
#import "DHLineView.h"
#import "DHControllPoint.h"

//Space between edge and side where y axis increase.
static CGFloat FacingSpace   = 20;

//Space between edge and side where x axis decrease.
static CGFloat LeadingSpace  = 100;

//Space between edge and side where y axis decrease.
static CGFloat BackingSpace  = 60;

//Space between edge and side where x axis increase.
static CGFloat TrailingSpace = 50;

static CGFloat XLabelHeight = 30;
static CGFloat YLabelWidth = 50;

@interface DHDynamicLineChart()
{
    NSInteger _xGridLineInterval;
    NSInteger _yGridLineInterval;
    
    CGPoint _leftTopOriginalPosition;
    CGPoint _rightBottomOriginalPosition;
    CGFloat _yAxisStartPosition;
    CGFloat _yAxisEndPosition;

    NSMutableArray<DHControllPoint *> *_controlPoints;
    NSArray<NSNumber *> *_xRatios;
    
    NSArray<NSString *> *_labelSource_x;
    NSArray<NSString *> *_labelSource_y;
    
    DHLineView *_lineView;
    
    BOOL _isUp;
}
@end

@implementation DHDynamicLineChart

- (instancetype)init {
    
    //Default labels and control positions
    return [self initWithXAxisLabels:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]
                         yAxisLabels:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]
              controlPointsByXRatios:@[@0.125,@0.25,@0.375,@0.5]
                            direction:DHDyanmicChartDirectionUp];
}

//Designated initializer.
- (instancetype)initWithXAxisLabels:(NSArray<NSString *> *)xLabels
                        yAxisLabels:(NSArray<NSString *> *)yLabels
             controlPointsByXRatios:(NSArray<NSNumber *> *)xRatios
                           direction:(DHDyanmicChartDirection)direction {

    if (self = [super init]) {
        
        _labelSource_x = xLabels;
        _labelSource_y = yLabels;
        _xRatios = xRatios;
        _isUp = direction == DHDyanmicChartDirectionUp;
        _controlPoints = [[NSMutableArray alloc] init];
        
        _lineView = [[DHLineView alloc] init];
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_lineView];
        
        //Default settings.
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
    [self drawGridLinesInRect:rect];
}

- (void)configureChartWithXAxisLabels:(NSArray<NSString *> *)xLabels
                          yAxisLabels:(NSArray<NSString *> *)yLabels
                               inRect:(CGRect)rect{

    CGFloat topSpace = _isUp ? FacingSpace : BackingSpace;
    CGFloat leftSpace = LeadingSpace;
    CGFloat buttomSpace = _isUp ? BackingSpace : FacingSpace;
    CGFloat rightSpace = TrailingSpace;
    CGFloat xLabelYPosition;
    CGFloat yLabelYScalor;
    
    _leftTopOriginalPosition = CGPointMake(leftSpace, topSpace);
    _rightBottomOriginalPosition = CGPointMake(rect.size.width - rightSpace, rect.size.height - buttomSpace);
    
    _xGridLineInterval = fabs(_rightBottomOriginalPosition.x - _leftTopOriginalPosition.x) / _labelSource_x.count;
    _yGridLineInterval = fabs(_rightBottomOriginalPosition.y - _leftTopOriginalPosition.y) / _labelSource_y.count;


    if (_isUp) {
        _yAxisStartPosition = rect.size.height - buttomSpace;
        xLabelYPosition = buttomSpace / 4 + _rightBottomOriginalPosition.y;
        yLabelYScalor = -1;
    }else {
        _yAxisStartPosition = _yGridLineInterval * (_labelSource_y.count - 1) + topSpace;
        xLabelYPosition = topSpace / 4;
        yLabelYScalor = 1;
    }
    _yAxisEndPosition = _yAxisStartPosition - _yGridLineInterval * (_labelSource_y.count - 1);

    //add labels for x axis
    for (int i = 0; i < _labelSource_x.count; i++) {
        
        [self addLabelWithFrame:CGRectMake(_leftTopOriginalPosition.x - _xGridLineInterval / 3 + i * _xGridLineInterval, xLabelYPosition, _xGridLineInterval * 2 / 3, XLabelHeight) Text:_labelSource_x[i]];
    }

    //add labels for y axis
    for (int i = 0; i < _labelSource_y.count; i++) {
        
        [self addLabelWithFrame:CGRectMake(_leftTopOriginalPosition.x / 4, (_isUp ? _yAxisStartPosition : _yAxisEndPosition) - _yGridLineInterval / 3 + yLabelYScalor * i * _yGridLineInterval, YLabelWidth, _yGridLineInterval * 2 / 3) Text:_labelSource_y[i]];
    }
}

- (void)addLabelWithFrame:(CGRect)frame Text:(NSString *)labelText {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = labelText;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
}

- (void)drawGridLinesInRect:(CGRect)rect {
    
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
        CGContextMoveToPoint(context, _leftTopOriginalPosition.x, _yAxisStartPosition - i * _yGridLineInterval);
        CGContextAddLineToPoint(context, _rightBottomOriginalPosition.x, _yAxisStartPosition - i * _yGridLineInterval);
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

- (CGFloat)validateValue:(CGFloat)value from:(CGFloat)fromValue to:(CGFloat)toValue {
    
    fromValue = MIN(fromValue, toValue);
    toValue = MAX(fromValue, toValue);
    
    if (value < fromValue) {
        return fromValue;
    }
    else if (value > toValue){
        return toValue;
    }
    else {
        return value;
    }
}

#pragma mark - API

- (void)setLineColor:(UIColor *)lineColor {
    _lineView.lineColor = lineColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineView.lineWidth = lineWidth;
}

- (void)resetLine {
    
    for (DHControllPoint *point in _controlPoints) {
        point.y = _yAxisStartPosition;
    }
    [_lineView drawLineWithControlPoints:_controlPoints];
}

- (void)refreshChart {
    [self setNeedsDisplay];
    [self resetLine];
}

- (void)refreshLineChartWithYRatio:(CGFloat)yRatio atIndex:(NSInteger)index {
    
    yRatio = [self validateValue:yRatio from:0.0 to:1.0];
    _controlPoints[index].y = _yAxisStartPosition - ((_labelSource_y.count - 1) * _yGridLineInterval) * yRatio;
    [_lineView drawLineWithControlPoints:_controlPoints];
}

- (void)refreshLineChartWithYRatios:(NSArray<NSNumber *> *)yRatios {

    NSUInteger loopCount = MIN(yRatios.count, _controlPoints.count);
    for (int i = 0; i < loopCount; i++) {
        [self refreshLineChartWithYRatio:((NSNumber *)yRatios[i]).floatValue atIndex:i];
    }
}

- (void)updateWithXAxisLabels:(NSArray<NSString *> *)xLabels
                  YAxisLabels:(NSArray<NSString *> *)yLabels
       controlPointsByXRatios:(NSArray<NSNumber *> *)xRatios
           immediatelyRefresh:(BOOL)refresh {

    _labelSource_x = xLabels;
    _labelSource_y = yLabels;
    _xRatios = xRatios;
    
    if (refresh) {
        [self refreshChart];
    }
}

- (void)setControlPointsWithXRatios:(NSArray<NSNumber *> *)xRatios {

    if (!xRatios) return;
    
    _xRatios = xRatios;
    [_controlPoints removeAllObjects];
    CGFloat chartWidth = _xGridLineInterval * _labelSource_x.count;
    [xRatios sortedArrayUsingSelector:@selector(compare:)];
    for(NSNumber *xRatioNum in xRatios)
    {
        CGFloat xRatio = [self validateValue:xRatioNum.floatValue from:0.0 to:1.0];
        CGFloat newPosition = xRatio * chartWidth + _leftTopOriginalPosition.x;
        [_controlPoints addObject:[[DHControllPoint alloc] initWithX:newPosition Y:_yAxisStartPosition]];
    }
}

@end
