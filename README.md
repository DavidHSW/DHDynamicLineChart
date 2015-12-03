# DHDynamicLineChart

##Feature

This chart allows you to:
* customize the control position of line
* dynamically control turning points at runtime;
* update the labels of x/y axis at runtime;<br>

and it is:
* self-adjusting in views of different size

##Installation

* Simply drag the folder `DHDynamicLineChart` into your project and import `DHDynamicLineChart.h` in your file:

        #import "DHDynamicLineChart.h"

* You also need to add `CoreGraphic` library into your project. 

##How to use

* Initialization:
    
        _xAxisLabels = @[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"];//Label titles
        _yAxisLabels = @[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"];
        _positions = @[@0.125,@0.25,@0.375,@1];
        
        _myLineChart = [[DHDynamicLineChart alloc] initWithFram:CGRectMake(0, 0, 200, 200)
                                                    xAxisLabels:_xAxisLabels
                                                    yAxisLabels:_yAxisLabels
                                       controlPointsXRatioValue:_positions];
                                       
        [self.view addSubview:_myLineChart];

  The `_positions` array indicates the control positions by ratio of x axis.

* Control line at different positions:

        [self.myLineChart refreshLineChartWithYValue:slider.value atIndex:self.index];

  The `index` indicates the order of control points.

* Update labels of x/y axises:

        [self.myLineChart updateLabelsOfXAxis:self.newXLabels  YAxis:self.newYLabels];

* When you update labels, you may also want to update control points:

        [self.myLineChart setControlPointsWithXRatioValues:self.newRatio];

#License
This repo is under MIT license.

