//
//  CALayer+SXCorner.m
//  VSocial
//
//  Created by vince_wang on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import "CALayer+SXCorner.h"
#import <ReactiveObjC/ReactiveObjC.h>
@implementation CALayer (SXCorner)

+ (CAShapeLayer *)cornerLayerWithtl:(CGFloat)tl tr:(CGFloat)tr bl:(CGFloat)bl br:(CGFloat)br size:(CGSize)size {
    CGFloat width = size.width;
    CGFloat height = size.height;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, tl)];
    [path addQuadCurveToPoint:CGPointMake(tl, 0) controlPoint:CGPointZero];
    
    [path addLineToPoint:CGPointMake(width-tr, 0)];
    [path addQuadCurveToPoint:CGPointMake(width, tr) controlPoint:CGPointMake(width, 0)];
    
    [path addLineToPoint:CGPointMake(width, height-br)];
    [path addQuadCurveToPoint:CGPointMake(width-br, height) controlPoint:CGPointMake(width, height)];
    
    [path addLineToPoint:CGPointMake(bl, height)];
    [path addQuadCurveToPoint:CGPointMake(0, height-bl) controlPoint:CGPointMake(0, height)];
    
    [path addLineToPoint:CGPointMake(0, tl)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = path.CGPath;
    return maskLayer;
}

+ (CAGradientLayer *)gradientLayerWithColors:(NSArray <UIColor *>*)colors size:(CGSize)size {
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,size.width,size.height);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    NSArray *cgColors = [[[colors rac_sequence] map:^id _Nullable(UIColor * _Nullable value) {
        return ((__bridge id)value.CGColor);
    }] array];
    NSArray *locations = @[@0,@1];
    if (colors.count > locations.count) {
        NSInteger temp = colors.count - locations.count;
        CGFloat value = 1.0/(temp + 1);
        NSMutableArray *m_locations = @[].mutableCopy;
        for (int i = 1; i <= temp; i ++) {
            [m_locations addObject:@(i * value)];
        }
        [m_locations insertObject:@0 atIndex:0];
        [m_locations addObject:@1];
        locations = m_locations;
    } else if (colors.count < locations.count) {
        NSInteger temp = locations.count - colors.count;
        NSMutableArray *m_cgColors = cgColors.mutableCopy;
        for (int i = 0; i < temp; i++) {
            [m_cgColors addObject:((__bridge id)colors.lastObject.CGColor)];
        }
    }
    gl.colors = cgColors;
    gl.locations = locations;
    return gl;
}

@end
