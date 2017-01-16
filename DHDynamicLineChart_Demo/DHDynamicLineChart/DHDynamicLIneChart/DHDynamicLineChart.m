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

static void *DHGridViewWidthContext = &DHGridViewWidthContext;

@interface DHDynamicLineChart()<DHGridViewDelegate>
{
    NSInteger _xGridLineInterval;
    NSInteger _yGridLineInterval;
    CGFloat _yAxisStartPosition;

    NSMutableArray<DHControllPoint *> *_controlPoints;
    NSArray<NSNumber *> *_controlPositionRatios;
    
    NSArray<NSString *> *_xLabelTitles;
    NSArray<NSString *> *_yLabelTitles;
    
    NSLayoutConstraint *_verticalConstraintsDirectionUp;
    NSLayoutConstraint *_verticalConstraintsDirectionDown;

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
        
        _verticalConstraintsDirectionUp = [NSLayoutConstraint constraintWithItem:_gridView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_xLabelContainer
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:-15];
        _verticalConstraintsDirectionDown = [NSLayoutConstraint constraintWithItem:_xLabelContainer
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_gridView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:-15];
        
        [NSLayoutConstraint activateConstraints:_isUp ? @[_verticalConstraintsDirectionUp] : @[_verticalConstraintsDirectionDown]];
        [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:_xLabelContainer
                                                                               attribute:NSLayoutAttributeLeading
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_gridView
                                                                               attribute:NSLayoutAttributeLeading
                                                                              multiplier:1.0
                                                                                constant:0]]];
        [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:_xLabelContainer
                                                                               attribute:NSLayoutAttributeTrailing
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_gridView
                                                                               attribute:NSLayoutAttributeTrailing
                                                                              multiplier:1.0
                                                                                constant:0]]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=15)-[_xLabelContainer]-(>=15)-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(_xLabelContainer)]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=15)-[_gridView]-(>=15)-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(_gridView)]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_yLabelContainer]-15-[_gridView]-10-|"
                                                                                        options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(_gridView, _yLabelContainer)]];
        
        [self resetChart];
        
        //Default settings.
        self.backgroundColor = [UIColor blackColor];
        _lineWidth = 1.0f;
        _gridLineWidth = 1.0f;
        _lineColor = [UIColor whiteColor];
        _gridLineColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setControlPointsWithXRatios:_controlPositionRatios];
}

#pragma mark - Util

- (void)setupAxisLabels {
    
    UILabel *label;
    UILabel *previousLabel;

    //Add x axis labels.
    for (int i = 0; i < _xLabelTitles.count; i++) {
        
        label = [self addLabelOnView:_xLabelContainer text:_xLabelTitles[i]];
        [self alignView:label afterView:previousLabel vertically:NO];
        
        [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:label
                                                                               attribute:NSLayoutAttributeCenterX
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_xLabelContainer
                                                                               attribute:NSLayoutAttributeTrailing
                                                                              multiplier:(i + CGFLOAT_MIN) / _xLabelTitles.count
                                                                                constant:0]]];
        previousLabel = label;
    }
    
    //Add y axis labels.
    previousLabel = nil;
    _yLabelTitles = _isUp ? [[_yLabelTitles reverseObjectEnumerator] allObjects] : _yLabelTitles;
    
    for (int i = 0; i < _yLabelTitles.count; i++){
        
        label = [self addLabelOnView:_yLabelContainer text:_yLabelTitles[i]];
        [self alignView:label afterView:previousLabel vertically:YES];
        
        [NSLayoutConstraint activateConstraints:@[[NSLayoutConstraint constraintWithItem:label
                                                                               attribute:NSLayoutAttributeCenterY
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:_yLabelContainer
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:((_isUp ? 1 : 0) + i + CGFLOAT_MIN) / _yLabelTitles.count
                                                                                constant:0]]];
        previousLabel = label;
    }
}

- (void)alignView:(UIView *)view afterView:(UIView *)previousView vertically:(BOOL)isVertical {
    
    NSString *direction = isVertical ? @"V" : @"H";
    NSString *corssDirection = isVertical ? @"H" : @"V";
    
    UIView *tempView = [[UIView alloc] init];
    NSString *key = [NSString stringWithFormat:@"label%p", view];
    NSString *preKey = [NSString stringWithFormat:@"label%p", previousView ?: tempView];
    
    NSDictionary *viewsDic = @{key: view, preKey: previousView ?: tempView};
    NSString *visualFormat;

    if (previousView) {
        visualFormat = [NSString stringWithFormat:@"%@:[%@]-(>=1)-[%@]", direction, preKey, key];
    }
    else {
        visualFormat = [NSString stringWithFormat:@"%@:[%@]", direction, key];
    }
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:viewsDic]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"%@:|[%@]|", corssDirection, key]
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:viewsDic]];

}

- (UILabel *)addLabelOnView:(UIView *)view text:(NSString *)text {
    
    UILabel *label = ({
        UILabel *l = [[UILabel alloc] init];
        l.translatesAutoresizingMaskIntoConstraints = NO;
        l.text = text;
        l.minimumScaleFactor = 0.2;
        l.adjustsFontSizeToFitWidth = YES;
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor whiteColor];
        l;
    });

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

- (void)resetChart{
    
    [self removeAllLabels];
    [self setupAxisLabels];
    [_gridView refreshWithXLineNum:_xLabelTitles.count YLineNum:_yLabelTitles.count];
}

#pragma mark - DHGridView delegate

- (void)didRedrawGridView:(DHGridView *)grieView {
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

- (void)refreshLineChartWithYRatio:(CGFloat)yRatio atIndex:(NSInteger)index {
    
    if (index < 0 || index >= _controlPoints.count) { return; }
    
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


- (void)updateWithXAxisLabelTitles:(NSArray<NSString *> *)xLabelTitles {
    
}

- (void)updateWithYAxisLabelTitles:(NSArray<NSString *> *)yLabelTitles {
    
}

- (void)updateWithControlPointsByXRatios:(NSArray<NSNumber *> *)xRatios {
    
}

- (void)updateWithDirection:(DHDyanmicChartDirection)direction {
    
}

- (void)updateWithXAxisLabelTitles:(NSArray<NSString *> *)xLabelTitles
                  YAxisLabelTitles:(NSArray<NSString *> *)yLabelTitles
            controlPointsByXRatios:(NSArray<NSNumber *> *)xRatios
                         direction:(DHDyanmicChartDirection)direction {

    _xLabelTitles = xLabelTitles;
    _yLabelTitles = yLabelTitles;
    _controlPositionRatios = xRatios;
    _isUp = direction == DHDyanmicChartDirectionUp;
    [_gridView refreshWithDirectionUp:_isUp];

    [self layoutIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        if (_isUp) {
            [NSLayoutConstraint deactivateConstraints:@[_verticalConstraintsDirectionDown]];
            [NSLayoutConstraint activateConstraints:@[_verticalConstraintsDirectionUp]];
        }
        else {
            [NSLayoutConstraint deactivateConstraints:@[_verticalConstraintsDirectionUp]];
            [NSLayoutConstraint activateConstraints:@[_verticalConstraintsDirectionDown]];
        }
        [self layoutIfNeeded];
    }];
    [self resetChart];
}

- (void)setControlPointsWithXRatios:(NSArray<NSNumber *> *)xRatios {

    if (!xRatios) return;
    
    xRatios = [[[NSSet setWithArray:xRatios] allObjects] sortedArrayUsingSelector:@selector(compare:)];

    [_controlPoints removeAllObjects];
    CGFloat chartWidth = _gridView.frame.size.width * (1.0 - 1.0 / _xLabelTitles.count);
    for(NSNumber *xRatioNum in xRatios){
        CGFloat xRatio = [self validateValue:xRatioNum.floatValue from:0.0 to:1.0];
        CGFloat newPosition = xRatio * chartWidth;
        [_controlPoints addObject:[[DHControllPoint alloc] initWithPoint:CGPointMake(newPosition, _gridView.yBase)]];
    }
}

@end
