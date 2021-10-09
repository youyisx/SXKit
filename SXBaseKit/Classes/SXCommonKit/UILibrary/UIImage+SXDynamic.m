//
//  UIImage+SXDynamic.m
//  VSocial
//
//  Created by vince_wang on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIImage+SXDynamic.h"
#import <SXCommonDefines.h>
@implementation UIImage (SXDynamic)

+ (UIImage *)sx_layerImageWithLayer:(CALayer *)layer {
    if (!layer) return nil;
    CGSize size = layer.frame.size;
    if (sx_sizeIsEmpty(size)) return nil;
    UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
    format.scale = 1;
    format.opaque = NO;
    UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
    UIImage *imageOut = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        CGContextRef context = rendererContext.CGContext;
        if (!context) return;
        [layer renderInContext:context];
    }];
    return imageOut;
}

- (UIImage * _Nonnull (^)(void))sx_resizeable {
    return ^(void) {
        return [self sx_resizeableImage];
    };
}

- (UIImage *)sx_resizeableImage{
    CGFloat top = self.size.height/2.0;
    CGFloat left = self.size.width/2.0;
    CGFloat bottom = self.size.height/2.0;
    CGFloat right = self.size.width/2.0;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right)
                                resizingMode:UIImageResizingModeStretch];
}

/**
 *  根据字符串生成二维码图片
 *
 *  @param code 二维码code
 *  @param size 生成图片大小
 *
 */
+ (UIImage *)sx_QRCodeFromString:(NSString *)code size:(CGFloat)size{
    //创建CIFilter 指定filter的名称为CIQRCodeGenerator
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //指定二维码的inputMessage,即你要生成二维码的字符串
    if (code.length == 0) code = @" ";
    [filter setValue:[code dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    //输出CIImage
    CIImage *ciImage = [filter outputImage];
    //对CIImage进行处理
    return [self sx_createfNonInterpolatedImageFromCIImage:ciImage withSize:size];
}

/**
 *  对CIQRCodeGenerator 生成的CIImage对象进行不插值放大或缩小处理
 *
 *  @param iamge 原CIImage对象
 *  @param size  处理后的图片大小
 *
 */
+ (UIImage *)sx_createfNonInterpolatedImageFromCIImage:(CIImage *)iamge withSize:(CGFloat)size{
    CGRect extent = iamge.extent;
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t with = scale * CGRectGetWidth(extent);
    size_t height = scale * CGRectGetHeight(extent);
    
    UIGraphicsBeginImageContext(CGSizeMake(with, height));
    CGContextRef bitmapContextRef = UIGraphicsGetCurrentContext();
    
    CIContext *context = [CIContext contextWithOptions:nil];
    //通过CIContext 将CIImage生成CGImageRef
    CGImageRef bitmapImage = [context createCGImage:iamge fromRect:extent];
    //在对二维码放大或缩小处理时,禁止插值
    CGContextSetInterpolationQuality(bitmapContextRef, kCGInterpolationNone);
    //对二维码进行缩放
    CGContextScaleCTM(bitmapContextRef, scale, scale);
    //将二维码绘制到图片上下文
    CGContextDrawImage(bitmapContextRef, extent, bitmapImage);
    //获得上下文中二维码
    UIImage *retVal =  UIGraphicsGetImageFromCurrentImageContext();
    CGImageRelease(bitmapImage);
    UIGraphicsEndImageContext();
    return retVal;
}

+ (UIImage * (^)(NSString *, CGFloat))sx_qrcode {
    return ^(NSString *qrcode, CGFloat size) {
        return [self sx_QRCodeFromString:qrcode size:size];
    };
}

#pragma mark - 压缩图片
/// 压缩图片到指定大小以内
- (NSData *)sx_compressWithMaxDataSizeKBytes:(CGFloat)size
{
    UIImage *image = self;
    
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    
    while (dataKBytes > size)
    {
        while (dataKBytes > size && maxQuality > 0.1f)
        {
            maxQuality = maxQuality - 0.1f;
            data = UIImageJPEGRepresentation(image, maxQuality);
            dataKBytes = data.length / 1000.0;
            if(dataKBytes <= size )
            {
                return data;
            }
        }
        UIImage *tempImg = [image sx_compressWidth:image.size.width * 0.8];
        if (!tempImg) {
            /// 容错
            return data;
        }
        image = tempImg;
        data = UIImageJPEGRepresentation(image, 1.0);
        dataKBytes = data.length / 1000.0;
        maxQuality = 0.9f;
    }
    return data;
}


/// 压缩图片到指定宽度
- (UIImage * _Nullable)sx_compressWidth:(CGFloat)width {
    if (width <= 0 || width >= self.size.width) return nil;
    CGFloat height = self.size.height/self.size.width * width;
    if (height <= 0) return nil;
    
    CGSize size = CGSizeMake(width, height);
    CGRect newRect = CGRectMake(0, 0, size.width, size.height);
    if (@available(iOS 10.0, *)) {
        UIGraphicsImageRendererFormat *format = nil;
        if (@available(iOS 11.0, *)) {
            format = [UIGraphicsImageRendererFormat preferredFormat];
        } else {
            format = [UIGraphicsImageRendererFormat defaultFormat];
        }
        format.opaque = NO;
        format.scale  = 1.0;

        UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
        UIImage *image                  = self;
        return [render imageWithActions:^(UIGraphicsImageRendererContext *_Nonnull rendererContext) {
            [image drawInRect:newRect];
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
        [self drawInRect:newRect];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

/// 获取图片平均颜色
- (UIColor *)sx_averageColor {
    unsigned char rgba[4] = {};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    if (!context) return nil;
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    if(rgba[3] > 0) {
        return [UIColor colorWithRed:((CGFloat)rgba[0] / rgba[3])
                               green:((CGFloat)rgba[1] / rgba[3])
                                blue:((CGFloat)rgba[2] / rgba[3])
                               alpha:((CGFloat)rgba[3] / 255.0)];
    } else {
        return [UIColor colorWithRed:((CGFloat)rgba[0]) / 255.0
                               green:((CGFloat)rgba[1]) / 255.0
                                blue:((CGFloat)rgba[2]) / 255.0
                               alpha:((CGFloat)rgba[3]) / 255.0];
    }
}
/// 获取图片平均颜色并加深该颜色
- (UIColor *)sx_averageDeepColor {
    unsigned char rgba[4] = {};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    if (!context) return nil;
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    CGFloat r = 1;
    CGFloat g = 1;
    CGFloat b = 1;
    CGFloat a = 1;
    
    if(rgba[3] > 0) {
        r = ((CGFloat)rgba[0] / rgba[3]);
        g = ((CGFloat)rgba[1] / rgba[3]);
        b = ((CGFloat)rgba[2] / rgba[3]);
        a = ((CGFloat)rgba[3] / 255.0);
    } else {
        r = ((CGFloat)rgba[0] / 255.0);
        g = ((CGFloat)rgba[1] / 255.0);
        b = ((CGFloat)rgba[2] / 255.0);
        a = ((CGFloat)rgba[3] / 255.0);
    }
    /// 让颜色再深一点
    CGFloat *temp;
    temp = r > g ? &r : &g;
    if (b > (*temp)) temp = &b;
    (*temp) += 0.1;
    if ((*temp) > 1) (*temp) = 1;
    a += 0.1;
    if (a > 1) a = 1;
    return [UIColor colorWithRed:r
                           green:g
                            blue:b
                           alpha:a];
    return nil;
}
@end
