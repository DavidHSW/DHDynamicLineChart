//
//  DHControllPoint.h
//  DHDynamicLineChart
//
//  Created by David Hu on 12/23/16.
//  Copyright © 2016 David HU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHControllPoint : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic, readonly) CGPoint position;

- (instancetype)initWithX:(CGFloat)x Y:(CGFloat)y;

@end
