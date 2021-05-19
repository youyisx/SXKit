//
//  UIView+SXCorner.m
//  VSocial
//
//  Created by vince_wang on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIView+SXCorner.h"
#import "CALayer+SXCorner.h"
#import "UIView+SXDynamic.h"

@implementation UIView (SXCorner)

- (void)sx_addCornerLayerWithtl:(CGFloat)tl tr:(CGFloat)tr bl:(CGFloat)bl br:(CGFloat)br {
    [self sx_addCornerLayerWithtl:tl tr:tr bl:bl br:br size:self.bounds.size];
}

- (void)sx_addCornerLayerWithtl:(CGFloat)tl tr:(CGFloat)tr bl:(CGFloat)bl br:(CGFloat)br size:(CGSize)size {
    CAShapeLayer *layer = [CAShapeLayer sx_cornerLayerWithtl:tl tr:tr bl:bl br:br size:size];
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    self.layer.mask = layer;
}

/// 会自动根据bounds的变化  而更新corner
- (void)sx_addAutoCornerLayerWithtl:(CGFloat)tl tr:(CGFloat)tr bl:(CGFloat)bl br:(CGFloat)br {
    self.sizeChangeHandler = ^(CGSize size, UIView * _Nonnull target) {
        if (CGSizeEqualToSize(CGSizeZero, size)) return;
        [target sx_addCornerLayerWithtl:tl tr:tr bl:bl br:br size:size];
    };
    CGSize currentSize = self.bounds.size;
    if (CGSizeEqualToSize(currentSize, CGSizeZero)) return;
    [self sx_addCornerLayerWithtl:tl tr:tr bl:bl br:br size:currentSize];
}

- (void)sx_addCorner:(CGFloat)corner {
    [self sx_addAutoCornerLayerWithtl:corner tr:corner bl:corner br:corner];
}

/// 给view 插入一个渐变layer
- (void)sx_addGradientBackLayerWithColors:(NSArray <UIColor *>*)colors
                                    start:(CGPoint)start
                                      end:(CGPoint)end {
    CGSize size = self.bounds.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) size = CGSizeMake(10, 10);
    CAGradientLayer *layer = [CALayer sx_gradientLayerWithColors:colors size:size start:start end:end];
    [self.layer addSublayer:layer];
    @weakify(layer)
    [[[self sx_sizeChangeSignal] takeUntil:layer.rac_willDeallocSignal] subscribeNext:^(UIView * _Nullable x) {
        @strongify(layer)
        layer.frame = x.bounds;
    }];
}
/// 移除渐变背景layer
- (void)sx_removeGradientBackLayer {
    NSArray <CALayer *>*layers =  [self.layer.sublayers copy];
    for (CALayer *layer in layers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
}

@end
