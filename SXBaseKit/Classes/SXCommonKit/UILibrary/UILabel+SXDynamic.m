//
//  UILabel+SXDynamic.m
//  VSocial
//
//  Created by vince_wang on 2021/3/10.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UILabel+SXDynamic.h"

@implementation UILabel (SXDynamic)

+ (UILabel * _Nonnull (^)(NSString * _Nullable))sx_label {
    return ^(NSString *txt) {
        UILabel *label = [[self class] new];
        label.text = txt;
        return label;
    };
}

- (UILabel * _Nonnull (^)(UIFont * _Nullable))sx_font {
    return ^(UIFont *font) {
        self.font = font;
        return self;
    };
}

- (UILabel * _Nonnull (^)(UIColor * _Nullable))sx_color {
    return ^(UIColor *color) {
        self.textColor = color;
        return self;
    };
}

- (UILabel * _Nonnull (^)(NSInteger))sx_lines {
    return ^(NSInteger lines) {
        self.numberOfLines = lines;
        return self;
    };
}

- (UILabel * _Nonnull (^)(NSTextAlignment))sx_alignment {
    return ^(NSTextAlignment lines) {
        self.textAlignment = lines;
        return self;
    };
}

- (void)sx_setLayoutPriorityDefaultHeight {
    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal] ;
    [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal] ;
}

/// 更新文本显示（text 可以是 nsstring 或者 nsattributed）
- (void)sx_updateText:(id)text {
    if ([text isKindOfClass:[NSString class]]) {
        self.text = text;
    } else if ([text isKindOfClass:[NSAttributedString class]]) {
        self.attributedText = text;
    } else {
        self.text = nil;
        self.attributedText = nil;
    }
}

@end
