//
//  DHControllPoint.m
//  DHDynamicLineChart
//
//  Created by David Hu on 12/23/16.
//  Copyright © 2016 David HU. All rights reserved.
//

#import "DHControllPoint.h"

@implementation DHControllPoint

- (instancetype)initWithX:(CGFloat)x Y:(CGFloat)y {
    
    if (self = [super init]) {
        
        _x = x;
        _y = y;
    }
    
    return self;
}

- (CGPoint)position {
    return CGPointMake(_x, _y);
}
@end
