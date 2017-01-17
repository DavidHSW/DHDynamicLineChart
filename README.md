# DHDynamicLineChart

##Feature

This chart allows you to:
* Customize the control position of line.
* Dynamically control turning points at runtime.
* Update the labels of x/y axis at runtime.<br>

and it is:
* Self-adjusting in views of different size(Autolayout).

##Demo

 ![img](https://github.com/DavidHSW/DHDynamicLineChart/blob/master/DemoGif.gif)

##Installation

* Simply drag the folder `DHDynamicLineChart` into your project and import `DHDynamicLineChart.h` in your file:

        #import "DHDynamicLineChart.h"

* You also need to add `CoreGraphic` library into your project. 

##How to use

* Initialization:
    
        _xAxisLabels = @[@"125",@"250",@"500",@"1000",@"2000",@"4000",@"8000",@"10000"];//Label titles
        _yAxisLabels = @[@"0",@"-20",@"-40",@"-60",@"-80",@"-100",@"-120",@"-140"];
        _positions = @[@0,@(1.0/7),@(2.0/7),@(3.0/7),@(4.0/7),@(5.0/7),@(6.0/7),@1];
        
        _myLineChart = [[DHDynamicLineChart alloc] initWithXAxisLabelTitles:_xAxisLabels
                                                           yAxisLabelTitles:_yAxisLabels
                                                     controlPointsByXRatios:_positions
                                                                  direction:DHDyanmicChartDirectionDown];//Facing up or down.
        //Set grid line and line...
                                       
        [self.view addSubview:_myLineChart];

  The `_positions` array indicates the control positions by ratio of x axis.

* Control line at different positions:

        [self.myLineChart refreshLineChartWithYRatio:yRatio atIndex:index];
        
        or
        [self.myLineChart refreshLineChartWithYRatios:yRatios];

  The `index` indicates the order of control points. The 'yRatio" indicates the 'actual value' / 'max value'([0,1]).

* Update labels of x/y axises:

        //X
        [self.myLineChart updateWithXAxisLabelTitles:xNewYLabels];
        //Y
        [self.myLineChart updateWithXAxisLabelTitles:yNewYLabels];
        //Or
        [self.myLineChart updateWithXAxisLabelTitles:xNewlabels
                                    YAxisLabelTitles:yNewLabels
                              controlPointsByXRatios:newControlXRatios
                                           direction:newDirection
                                            animated:YES
                                          completion:nil];

* When you update labels, you may want to update control points:

        [self.myLineChart updateWithControlPointsByXRatios:xNewRatios];
        
* If you want to flip chart upside down:

        [self.myLineChart switchDirectionAnimated:YES completion:^(DHDynamicLineChart * _Nonnull chart) {
                //Do some additional settings with 'chart'.
        }];

* Check demo for more details. Enjoy!

#License

This repo is under MIT license.

