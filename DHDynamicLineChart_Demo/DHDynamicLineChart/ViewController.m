//
//  ViewController.m
//  DHDynamicLineChart
//
//  Created by Hu Siwei on 15/11/30.
//  Copyright (c) 2015年 David HU. All rights reserved.
//

#import "ViewController.h"
#import "DHDynamicLineChart.h"

@interface ViewController ()<DHDynamicLineChartDataSource>

@property (strong, nonatomic) DHDynamicLineChart *myLineChart;
@property (copy,nonatomic)NSArray *controlPoints_xRatio;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _controlPoints_xRatio = @[@0.125,@0.25,@0.375,@1];
    _myLineChart = [[DHDynamicLineChart alloc] initWithFram:CGRectMake(0, 0, 200, 200)
                                                xAxisLabels:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]
                                                yAxisLabels:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]
                                   controlPointsXRatioValue:_controlPoints_xRatio];
    [self.view addSubview:self.myLineChart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateLineChart:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if(slider.tag >= 0 && slider.tag < self.controlPoints_xRatio.count){
        [self.myLineChart refreshLineChartWithYValue:slider.value atIndex:slider.tag];
    }
}
- (IBAction)changeChart:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    if (seg.selectedSegmentIndex == 0) {
        [self.myLineChart updateLabelsOfXAxis:@[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"]  YAxis:@[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"]];
    }else {
        [self.myLineChart updateLabelsOfXAxis:@[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"] YAxis:@[@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35"]];
    }
}

@end
