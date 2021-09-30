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


/// 压缩图片到指定大小以内 size 为 KB单位
- (NSData *)sx_compressWithMaxDataSizeKBytes:(CGFloat)size;
/// 压缩图片到指定宽度
- (UIImage * _Nullable)sx_compressWidth:(CGFloat)width;
/// 获取图片平均颜色
- (UIColor *)sx_averageColor;
/// 获取图片平均颜色并加深该颜色
- (UIColor *)sx_averageDeepColor;
@end


NS_ASSUME_NONNULL_END
