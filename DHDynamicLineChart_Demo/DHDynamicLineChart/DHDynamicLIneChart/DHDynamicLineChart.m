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
        
        _gridView = [[DHGridView alloc] initWithDirectionUp:_isUp];
        _gridView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_gridView];
        
        _lineView = [[DHLineView alloc] init];
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_gridView addSubview:_lineView];
        
        _xLabelContainer = [[UIView alloc] init];
        _xLabelContainer.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_xLabelContainer];
        
        _yLabelContainer = [[UIView alloc] init];
        _yLabelContainer.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_yLabelContainer];
        
        NSString *yLabelContainerVisualFormat = _isUp ? @"V:|-10-[_gridView]-10-[_xLabelContainer]-10-|" : @"V:|-10-[_xLabelContainer]-10-[_gridView]-10-|";

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
    
    [self removeAllLabels];
    [self setupAxisLabels];
    [self setControlPointsWithXRatios:_xRatios];
    [_gridView refreshWithXLineNum:_labelSource_x.count YLineNum:_labelSource_y.count];
}

- (void)setupAxisLabels {
    
    UILabel *label;
    UILabel *previousLabel;
    NSString *visualFormat;
    
    //add labels for x axis
    for (int i = 0; i < _labelSource_x.count; i++) {
        
        label = [self addLabelOnView:_xLabelContainer text:_labelSource_x[i]];
        
        NSDictionary *viewsDic;
        if (i == 0) {
            visualFormat = @"H:[label]";
            viewsDic = NSDictionaryOfVariableBindings(label);
        }
        else {
            visualFormat = @"H:[previousLabel]-(>=1)-[label]";
            viewsDic = NSDictionaryOfVariableBindings(previousLabel, label);
        }
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:viewsDic]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:viewsDic]];
        [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:label
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_xLabelContainer
                                                                               attribute:NSLayoutAttributeTrailing
                                                                              multiplier:(i + CGFLOAT_MIN) / _labelSource_x.count
                                                                                constant:0]]];
        previousLabel = label;
    }
    
    //add labels for y axis
    _labelSource_y = _isUp ? [[_labelSource_y reverseObjectEnumerator] allObjects] : _labelSource_y;
    for (int i = 0; i < _labelSource_y.count; i++) {
        
        label = [self addLabelOnView:_yLabelContainer text:_labelSource_y[i]];
        
        NSDictionary *viewsDic;
        if (i == 0) {
            visualFormat = @"V:[label]";
            viewsDic = NSDictionaryOfVariableBindings(label);
        }
        else {
            visualFormat = @"V:[previousLabel]-(>=1)-[label]";
            viewsDic = NSDictionaryOfVariableBindings(previousLabel, label);
        }
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:viewsDic]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(label)]];
        CGFloat multiplier = ((_isUp ? 1 : 0) + i + CGFLOAT_MIN) / _labelSource_y.count;
        [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:label
                                                                               attribute:NSLayoutAttributeCenterY
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_yLabelContainer
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:multiplier
                                                                                constant:0]]];
        
        previousLabel = label;
    }
}

- (UILabel *)addLabelOnView:(UIView *)view text:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    return label;
}

- (void)removeAllLabels {
    
    NSMutableArray *subviews = [[NSMutableArray alloc] init];
    [subviews addObjectsFromArray:[_xLabelContainer subviews]];
    [subviews addObjectsFromArray:[_yLabelContainer subviews]];
    
    for(UIView *subV in subviews)
    {
        [subV removeFromSuperview];
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
        point.y = _gridView.yBase;
    }
    [_lineView drawLineWithControlPoints:_controlPoints];
}

- (void)refreshChart {
    [self setNeedsDisplay];
    [self resetLine];
}

- (void)refreshLineChartWithYRatio:(CGFloat)yRatio atIndex:(NSInteger)index {
    
    yRatio = [self validateValue:yRatio from:0.0 to:1.0];
    _controlPoints[index].y = _gridView.yBase - _gridView.yRange * yRatio;
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
    CGFloat chartWidth = _gridView.frame.size.width;
    [xRatios sortedArrayUsingSelector:@selector(compare:)];
    for(NSNumber *xRatioNum in xRatios)
    {
        CGFloat xRatio = [self validateValue:xRatioNum.floatValue from:0.0 to:1.0];
        CGFloat newPosition = xRatio * chartWidth;
        [_controlPoints addObject:[[DHControllPoint alloc] initWithX:newPosition Y:_yAxisStartPosition]];
    }
}

@end
