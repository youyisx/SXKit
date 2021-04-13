//
//  UIButton+SXDynamic.m
//  VSocial
//
//  Created by vince_wang on 2021/2/5.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIButton+SXDynamic.h"

@implementation UIButton (SXDynamic)
- (void)sx_vertical {
    [self sx_verticalOffset:2];
}
- (void)sx_verticalOffset:(CGFloat)value {
//    [self sizeToFit];
    UIImage *img = nil;
    if (self.isSelected) img = [self imageForState:UIControlStateSelected];
    if (img == nil) img = [self imageForState:UIControlStateNormal];
    CGFloat imageW = img.size.width;
    CGFloat imageH = img.size.height;
    
    NSString *title = nil;
    if (self.isSelected) title = [self titleForState:UIControlStateSelected];
    if (title.length == 0) title = [self titleForState:UIControlStateNormal];
    UIFont *font = self.titleLabel.font;
    if (font == nil) font = [UIFont systemFontOfSize:14];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : font}];
    CGFloat titleW = titleSize.width;
    CGFloat titleH = titleSize.height;
    
    //图片上文字下
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW, -imageH-value, 0.f)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-titleH-value, 0.f, 0.f,-titleW)];
}

/// 设置图片在右边显示

- (void)sx_rightImage {
    [self sx_rightImageOffset:2];
}
- (void)sx_rightImageOffset:(CGFloat)value {
    [self sizeToFit];
    CGFloat imageW = self.imageView.frame.size.width;
    CGFloat titleW = self.titleLabel.frame.size.width;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageW-value, 0, imageW+value)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleW+value, 0, -titleW-value)];
}

+ (UIButton * _Nonnull (^)(NSString * _Nullable))sx_button {
    return ^(NSString *title) {
        UIButton *btn = [[self class] buttonWithType:UIButtonTypeCustom];
        [btn setTitle:title forState:UIControlStateNormal];
        return btn;
    };
}

- (UIButton * _Nonnull (^)(UIFont * _Nullable))sx_font {
    return ^(UIFont *font) {
        self.titleLabel.font = font;
        return self;
    };
}

- (UIButton * _Nonnull (^)(UIColor * _Nullable))sx_color {
    return ^(UIColor *color) {
        [self setTitleColor:color forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton * (^)(UIColor *_Nullable,UIControlState))sx_color1 {
    return ^(UIColor *color, UIControlState state) {
        [self setTitleColor:color forState:state];
        return self;
    };
}

- (UIButton * _Nonnull (^)(UIImage * _Nullable))sx_image {
    return ^(UIImage *image) {
        [self setImage:image forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton * (^)(UIImage *_Nullable,UIControlState))sx_image1 {
    return ^(UIImage *image, UIControlState state) {
        [self setImage:image forState:state];
        return self;
    };
}
@end
