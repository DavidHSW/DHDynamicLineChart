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

@interface DHDynamicLineChart()<DHGridViewDelegate>
{
    NSInteger _xGridLineInterval;
    NSInteger _yGridLineInterval;
    CGFloat _yAxisStartPosition;

    NSMutableArray<DHControllPoint *> *_controlPoints;
    NSArray<NSNumber *> *_controlPositionRatios;
    
    NSArray<NSString *> *_xLabelTitles;
    NSArray<NSString *> *_yLabelTitles;
    
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
    return [self initWithXAxisLabelTitles:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]
                         yAxisLabelTitles:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]
                   controlPointsByXRatios:@[@0.125,@0.25,@0.375,@0.5]
                                direction:DHDyanmicChartDirectionUp];
}

//Designated initializer.
- (instancetype)initWithXAxisLabelTitles:(NSArray<NSString *> *)xLabelTitles
                        yAxisLabelTitles:(NSArray<NSString *> *)yLabelTitles
                  controlPointsByXRatios:(NSArray<NSNumber *> *)xRatios
                               direction:(DHDyanmicChartDirection)direction {

    if (self = [super init]) {
        
        _xLabelTitles = xLabelTitles;
        _yLabelTitles = yLabelTitles;
        _controlPositionRatios = xRatios;
        _isUp = direction == DHDyanmicChartDirectionUp;
        _controlPoints = [[NSMutableArray alloc] init];
        
        _gridView = [[DHGridView alloc] initWithDirectionUp:_isUp];
        _gridView.translatesAutoresizingMaskIntoConstraints = NO;
        _gridView.delegate = self;
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
        
        NSString *yLabelContainerVisualFormat = _isUp ? @"V:|-10-[_gridView]-15-[_xLabelContainer]-15-|" : @"V:|-15-[_xLabelContainer]-15-[_gridView]-10-|";
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:yLabelContainerVisualFormat
                                                                                        options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(_gridView, _xLabelContainer)]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_yLabelContainer]-15-[_gridView]-10-|"
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
    [_gridView refreshWithXLineNum:_xLabelTitles.count YLineNum:_yLabelTitles.count];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setControlPointsWithXRatios:_controlPositionRatios];
}

- (void)setupAxisLabels {
    
    UILabel *label;
    UILabel *previousLabel;
    NSString *visualFormat;
    
    //add x axis labels.
    for (int i = 0; i < _xLabelTitles.count; i++) {
        
        label = [self addLabelOnView:_xLabelContainer text:_xLabelTitles[i]];
        
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
                                                                              multiplier:(i + CGFLOAT_MIN) / _xLabelTitles.count
                                                                                constant:0]]];
        previousLabel = label;
    }
    
    //add y axis labels.
    _yLabelTitles = _isUp ? [[_yLabelTitles reverseObjectEnumerator] allObjects] : _yLabelTitles;
    for (int i = 0; i < _yLabelTitles.count; i++) {
        
        label = [self addLabelOnView:_yLabelContainer text:_yLabelTitles[i]];
        
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
        CGFloat multiplier = ((_isUp ? 1 : 0) + i + CGFLOAT_MIN) / _yLabelTitles.count;
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
    
    NSArray *subviews = [[_xLabelContainer subviews] arrayByAddingObjectsFromArray:[_yLabelContainer subviews]];
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

#pragma mark - DHGridView delegate

- (void)didRedrawedGridView:(DHGridView *)grieView {
    [self resetLine];
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
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self setNeedsDisplay];
}

- (void)refreshLineChartWithYRatio:(CGFloat)yRatio atIndex:(NSInteger)index {
    
    yRatio = [self validateValue:yRatio from:0.0 to:1.0];
    _controlPoints[index].y = _gridView.yBase - _gridView.yRange * yRatio;
    [_lineView drawLineWithControlPoints:_controlPoints];
}

- (void)refreshLineChartWithYRatios:(NSArray<NSNumber *> *)yRatios {

    NSUInteger loopCount = MIN(yRatios.count, _controlPoints.count);
    for (int i = 0; i < loopCount; i++) {
        [self refreshLineChartWithYRatio:yRatios[i].floatValue atIndex:i];
    }
}

- (void)updateWithXAxisLabelTitles:(NSArray<NSString *> *)xLabelTitles
                  YAxisLabelTitles:(NSArray<NSString *> *)yLabelTitles
            controlPointsByXRatios:(NSArray<NSNumber *> *)xRatios {

    _xLabelTitles = xLabelTitles;
    _yLabelTitles = yLabelTitles;
    _controlPositionRatios = xRatios;
    [self refreshChart];
}

- (void)setControlPointsWithXRatios:(NSArray<NSNumber *> *)xRatios {

    if (!xRatios) return;
    
    _controlPositionRatios = xRatios;
    [_controlPositionRatios sortedArrayUsingSelector:@selector(compare:)];

    [_controlPoints removeAllObjects];
    CGFloat chartWidth = _gridView.frame.size.width;
    for(NSNumber *xRatioNum in xRatios)
    {
        CGFloat xRatio = [self validateValue:xRatioNum.floatValue from:0.0 to:1.0];
        CGFloat newPosition = xRatio * chartWidth;
        [_controlPoints addObject:[[DHControllPoint alloc] initWithPoint:CGPointMake(newPosition, _yAxisStartPosition)]];
    }
}

@end
