//
//  DHControllPoint.m
//  DHDynamicLineChart
//
//  Created by David Hu on 12/23/16.
//  Copyright © 2016 David HU. All rights reserved.
//

#import "DHControllPoint.h"

@implementation DHControllPoint

- (instancetype)initWithPoint:(CGPoint)point {

    if (self = [super init]) {
        
        _x = point.x;
        _y = point.y;
    }
    
    return self;
}

- (CGPoint)position {
    return CGPointMake(_x, _y);
}
@end
