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

- (void)addCorner:(CGFloat)corner {
    [self sx_addAutoCornerLayerWithtl:corner tr:corner bl:corner br:corner];
}


@end
