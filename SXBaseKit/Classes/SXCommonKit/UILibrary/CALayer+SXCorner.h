//
//  CALayer+SXCorner.h
//  VSocial
//
//  Created by vince_wang on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (SXCorner)

+ (CAShapeLayer *)sx_cornerLayerWithtl:(CGFloat)tl tr:(CGFloat)tr bl:(CGFloat)bl br:(CGFloat)br size:(CGSize)size;

+ (CAGradientLayer *)sx_gradientLayerWithColors:(NSArray <UIColor *>*)colors size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
