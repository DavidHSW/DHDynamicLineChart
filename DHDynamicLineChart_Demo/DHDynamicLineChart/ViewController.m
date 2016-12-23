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
    _myLineChart = [[DHDynamicLineChart alloc] initWithXAxisLabels:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]
                                                       yAxisLabels:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]
                                            controlPointsByXRatios:_controlPoints_xRatio];
    _myLineChart.translatesAutoresizingMaskIntoConstraints = NO;
    _myLineChart.backgroundColor = [UIColor lightGrayColor];
    _myLineChart.gridLineColor = [UIColor whiteColor];
    _myLineChart.gridLineWidth = 1.0f;
    _myLineChart.lineColor = [UIColor redColor];
    _myLineChart.lineWidth = 1.0f;
    [self.view addSubview:_myLineChart];

    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_myLineChart(300)]"
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
        [self.myLineChart updateWithXAxisLabels:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]
                                    YAxisLabels:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]
                         controlPointsByXRatios:@[@0,@0.125,@0.25,@0.375]
                            immediatelyRefresh:YES];
    }
    else if (seg.selectedSegmentIndex == 1) {
        [self.myLineChart updateWithXAxisLabels:@[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"]
                                    YAxisLabels:@[@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35"]
                         controlPointsByXRatios:@[@0,@(1.0/7),@(2.0/7),@(3.0/7)]
                            immediatelyRefresh:YES];
    }
    else if (seg.selectedSegmentIndex == 2) {
        [self.myLineChart refreshLineChartWithYRatios:@[@0.5,@0.6,@0.7,@0.8]];
    }
    else {
        [self.myLineChart resetLine];
    }
}

@end
