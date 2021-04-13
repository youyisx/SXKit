//
//  UIButton+SXDynamic.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/2/5.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SXDynamic)
/// 图片 文字上下排列
- (void)sx_vertical;
- (void)sx_verticalOffset:(CGFloat)value;
/// 设置图片在右边显示
- (void)sx_rightImage;
- (void)sx_rightImageOffset:(CGFloat)value;

+ (UIButton * (^)(NSString *_Nullable))sx_button;
- (UIButton * (^)(UIFont *_Nullable))sx_font;
- (UIButton * (^)(UIColor *_Nullable))sx_color;
- (UIButton * (^)(UIColor *_Nullable,UIControlState))sx_color1;
- (UIButton * (^)(UIImage *_Nullable))sx_image;
- (UIButton * (^)(UIImage *_Nullable,UIControlState))sx_image1;
@end

NS_ASSUME_NONNULL_END
