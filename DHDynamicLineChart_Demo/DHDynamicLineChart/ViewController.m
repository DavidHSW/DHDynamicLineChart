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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _controlPoints_xRatio = @[@0,@0.125,@0.25,@0.375];
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

- (IBAction)updateLineChart:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if(slider.tag >= 0 && slider.tag < self.controlPoints_xRatio.count){
        [self.myLineChart refreshLineChartWithYRatio:slider.value / slider.maximumValue atIndex:slider.tag];
    }
}

- (IBAction)changeChart:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if (seg.selectedSegmentIndex == 0) {
        [self.myLineChart updateWithXAxisLabelTitles:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]
                                    YAxisLabelTitles:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]
                              controlPointsByXRatios:@[@0,@0.125,@0.25,@0.375]
                                           direction:DHDyanmicChartDirectionDown];
    }
    else if (seg.selectedSegmentIndex == 1) {
        [self.myLineChart updateWithXAxisLabelTitles:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]
                                    YAxisLabelTitles:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]
                              controlPointsByXRatios:@[@0,@0.125,@0.25,@0.375]
                                           direction:DHDyanmicChartDirectionUp];

    }
    else if (seg.selectedSegmentIndex == 2) {
        [self.myLineChart refreshLineChartWithYRatios:@[@0.5,@0.6,@0.7,@0.8]];
    }
    else {
        [self.myLineChart updateWithXAxisLabelTitles:@[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"]
                                    YAxisLabelTitles:@[@"0",@"5",@"10",@"15",@"20",@"25"]
                              controlPointsByXRatios:@[@0,@(1.0/7),@(2.0/7),@(3.0/7)]
                                           direction:DHDyanmicChartDirectionUp];
    }
}

@end
