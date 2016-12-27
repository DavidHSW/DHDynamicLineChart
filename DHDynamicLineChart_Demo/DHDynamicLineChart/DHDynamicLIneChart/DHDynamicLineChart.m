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
#import "DHGridView.h"

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
    DHGridView *_gridView;
    UIView *_xLabelContainer;
    UIView *_yLabelContainer;
    
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
        
        _gridView = [[DHGridView alloc] initWithDirectionUp:direction == DHDyanmicChartDirectionUp];
        _gridView.frame = CGRectMake(100, 50, 900, 300);
        [self addSubview:_gridView];
        
        _lineView = [[DHLineView alloc] init];
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _lineView.frame = CGRectMake(0, 0, 900, 300);
        [_gridView addSubview:_lineView];
        
        _xLabelContainer = [[UIView alloc] init];
        _xLabelContainer.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_xLabelContainer];
        
        _yLabelContainer = [[UIView alloc] init];
        _yLabelContainer.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_yLabelContainer];
        
        NSString *yLabelContainerVisualFormat;
        if (_isUp) {
            yLabelContainerVisualFormat = @"V:|-15-[_gridView]-10-[_xLabelContainer]-10-|";
        }
        else {
            yLabelContainerVisualFormat = @"V:|-10-[_xLabelContainer]-10-[_gridView]-10-|";
        }
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:yLabelContainerVisualFormat
                                                                                        options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(_gridView, _xLabelContainer)]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_yLabelContainer]-10-[_gridView]-10-|"
                                                                                        options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(_gridView, _yLabelContainer)]];
        
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
    
//    [self removeAllLabels];
    [self configureChartWithXAxisLabels:_labelSource_x yAxisLabels:_labelSource_y inRect:rect];
    [self setControlPointsWithXRatios:_xRatios];
    [_gridView refreshWithXLineNum:_labelSource_x.count YLineNum:_labelSource_y.count];
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

    
    UILabel *label;
    UILabel *previousLabel;
    NSString *visualFormat;
    
    //add labels for x axis
    for (int i = 0; i < _labelSource_x.count; i++) {
        
//        [self addLabelWithFrame:CGRectMake(_leftTopOriginalPosition.x - _xGridLineInterval / 3 + i * _xGridLineInterval, xLabelYPosition, _xGridLineInterval * 2 / 3, XLabelHeight) Text:_labelSource_x[i]];
        
        label = [self addLabelOnView:_xLabelContainer text:_labelSource_x[i]];
        NSDictionary *viewDic = NSDictionaryOfVariableBindings(label);
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:viewDic]];
        if (i == 0) {
            visualFormat = @"H:[label]";
        }
        else if (i < _labelSource_x.count - 1) {
            visualFormat = @"H:[previousLabel]-(>=0)-[label]";
            viewDic = NSDictionaryOfVariableBindings(previousLabel, label);
        }
        else {
            visualFormat = @"H:[previousLabel]-(>=0)-[label]";
            viewDic = NSDictionaryOfVariableBindings(previousLabel, label);
        }
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:viewDic]];
        [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:label
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_xLabelContainer
                                                                               attribute:NSLayoutAttributeLeading
                                                                              multiplier:1.0f
                                                                                constant:_xLabelContainer.frame.size.width * i / _labelSource_x.count]]];
        previousLabel = label;
    }
    
    //add labels for y axis
    for (int i = 0; i < _labelSource_y.count; i++) {
        
//        [self addLabelWithFrame:CGRectMake(_leftTopOriginalPosition.x / 4, (_isUp ? _yAxisStartPosition : _yAxisEndPosition) - _yGridLineInterval / 3 + yLabelYScalor * i * _yGridLineInterval, YLabelWidth, _yGridLineInterval * 2 / 3) Text:_labelSource_y[i]];
        
        label = [self addLabelOnView:_yLabelContainer text:_labelSource_y[i]];
        NSDictionary *viewDic = NSDictionaryOfVariableBindings(label);
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:viewDic]];
        if (i == 0) {
            visualFormat = @"V:[label]";
        }
        else if (i < _labelSource_y.count - 1) {
            visualFormat = @"V:[previousLabel]-(>=0)-[label]";
            viewDic = NSDictionaryOfVariableBindings(previousLabel, label);
        }
        else {
            visualFormat = @"V:[previousLabel]-(>=0)-[label]";
            viewDic = NSDictionaryOfVariableBindings(previousLabel, label);
        }
        
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:viewDic]];
        [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:label
                                                                               attribute:NSLayoutAttributeCenterY
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_yLabelContainer
                                                                               attribute:NSLayoutAttributeTop
                                                                              multiplier:1.0f
                                                                                constant:_yLabelContainer.frame.size.height * i / _labelSource_y.count]]];
        previousLabel = label;
    }
    
}

- (UILabel *)addLabelOnView:(UIView *)view text:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    return label;
}

- (void)removeAllLabels {
    
    for(UIView *subV in [self subviews])
    {
        if (![subV isKindOfClass:[DHLineView class]] && ![subV isKindOfClass:[DHGridView class]]) {
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
    _controlPoints[index].y = _gridView.yBase - _gridView.yRange * yRatio;//_yAxisStartPosition - ((_labelSource_y.count - 1) * _yGridLineInterval) * yRatio;
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
