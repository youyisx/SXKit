//
//  CALayer+SXCorner.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (SXCorner)

+ (CAShapeLayer *)cornerLayerWithtl:(CGFloat)tl tr:(CGFloat)tr bl:(CGFloat)bl br:(CGFloat)br size:(CGSize)size;

+ (CAGradientLayer *)gradientLayerWithColors:(NSArray <UIColor *>*)colors size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
