//
//  ViewController.m
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/11/30.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import "ViewController.h"
#import "DHDynamicLIneChart/DHDynamicLineChart.h"
#import "DHDynamicLIneChart/DHLineView.h"

@interface ViewController ()

@property (strong, nonatomic) DHDynamicLineChart *myLineChart;
@property (copy,nonatomic)NSArray *controlPoints_xRatio;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _controlPoints_xRatio = @[@0,@(1.0/7),@(2.0/7),@(3.0/7),@(4.0/7),@(5.0/7),@(6.0/7),@1];
    _myLineChart = [[DHDynamicLineChart alloc] initWithXAxisLabelTitles:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]
                                                       yAxisLabelTitles:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]
                                                 controlPointsByXRatios:_controlPoints_xRatio
                                                              direction:DHDyanmicChartDirectionDown];
    _myLineChart.translatesAutoresizingMaskIntoConstraints = NO;
    _myLineChart.backgroundColor = [UIColor colorWithRed:15.0/255.0 green:115.0/255.0 blue:1 alpha:1];
    _myLineChart.gridLineColor = [UIColor whiteColor];
    _myLineChart.gridLineWidth = 1.0f;
    _myLineChart.lineColor = [UIColor whiteColor];
    _myLineChart.lineWidth = 3.0f;
    [self.view addSubview:_myLineChart];

    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_myLineChart(400)]"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_myLineChart)]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_myLineChart]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(_myLineChart)]];
}

- (void)resetSliders {
    for (UISlider *slider in self.sliders) {
        slider.value = 0;
    }
}

- (IBAction)updateLineChart:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if(slider.tag >= 0 && slider.tag < self.controlPoints_xRatio.count){
        [self.myLineChart refreshLineChartWithYRatio:slider.value / slider.maximumValue atIndex:slider.tag];
    }
}

- (IBAction)changeChart:(id)sender {
    
    [self resetSliders];

    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0) {
        
        _controlPoints_xRatio = @[@0,@(1.0/7),@(2.0/7),@(3.0/7),@(4.0/7),@(5.0/7),@(6.0/7),@1];
        [self.myLineChart updateWithXAxisLabelTitles:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]
                                    YAxisLabelTitles:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]
                              controlPointsByXRatios:_controlPoints_xRatio
                                           direction:DHDyanmicChartDirectionDown];
    }
    else if (btn.tag == 1) {
        
        _controlPoints_xRatio = @[@0,@(1.0/7),@(2.0/7),@(3.0/7),@(4.0/7),@(5.0/7),@(6.0/7),@1];
        [self.myLineChart updateWithXAxisLabelTitles:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]
                                    YAxisLabelTitles:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]
                              controlPointsByXRatios:_controlPoints_xRatio
                                           direction:DHDyanmicChartDirectionUp];
    }
    else if (btn.tag == 2) {
        
        [self.myLineChart updateWithXAxisLabelTitles:@[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"]
                                    YAxisLabelTitles:@[@"0",@"5",@"10",@"15",@"20",@"25"]
                              controlPointsByXRatios:nil//Use default control position.
                                           direction:DHDyanmicChartDirectionUp];
    }
}

- (IBAction)randomYValues:(id)sender {
    
    [self resetSliders];
    NSMutableArray *yValues = [[NSMutableArray alloc] init];
    for (int i = 0; i<100; i++) {
        [yValues addObject:@((arc4random() % 10) / 10.0)];
    }
    [self.myLineChart refreshLineChartWithYRatios:yValues];
}

- (IBAction)updateControlPoints:(id)sender {
    
    [self resetSliders];
    NSMutableArray *xRatios = [[NSMutableArray alloc] init];
    for (int i = 0; i<30; i++) {
        [xRatios addObject:@((arc4random() % 1000) / 1000.0)];
    }
    [self.myLineChart updateWithControlPointsByXRatios:xRatios];
}

- (IBAction)updateXLabels:(id)sender {
    
    [self resetSliders];
    [self.myLineChart updateWithXAxisLabelTitles:@[@"First",@"Second",@"Third",@"Fourth",@"Fifth",@"Sixth",@"Seventh"]];
    [self.myLineChart updateWithControlPointsByXRatios:nil];
}

- (IBAction)updateYLabels:(id)sender {
    
    [self resetSliders];
    [self.myLineChart updateWithYAxisLabelTitles:@[@"1000",@"2000",@"3000",@"4000",@"5000",@"6000",@"7000"]];
}

- (IBAction)switchDirection:(id)sender {
    
    [self resetSliders];
    [self.myLineChart switchDirection];
}

@end
