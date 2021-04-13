//
//  UIImage+SXDynamic.h
//  VSocial
//
//  Created by vince_wang on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SXDynamic)

+ (instancetype)sx_layerImageWithLayer:(CALayer *)layer;

- (UIImage * (^)(void))sx_resizeable;


+ (UIImage * (^)(NSString *, CGFloat))sx_qrcode;

@end

NS_ASSUME_NONNULL_END
