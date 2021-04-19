//
//  NSMutableAttributedString+SXDynamic.m
//  VSocial
//
//  Created by vince on 2021/3/11.
//  Copyright © 2021 vince. All rights reserved.
//

#import "NSMutableAttributedString+SXDynamic.h"
#import "SXValidLibrary.h"
@implementation NSMutableAttributedString (SXDynamic)

+ (NSMutableAttributedString * (^)(NSString *_Nullable))sx_str {
    return ^(NSString *txt) {
        NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:sx_stringWithObject(txt)];
        return result;
    };
}

- (NSMutableAttributedString * (^)(UIFont *_Nonnull, NSRange))sx_font {
    return ^(UIFont *font, NSRange range) {
        if (range.location + range.length > self.length) return self;
        [self addAttributes:@{NSFontAttributeName : font} range:range];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(UIFont * _Nonnull, NSString * _Nonnull))sx_font1 {
    return ^(UIFont *font, NSString *txt) {
        NSString *target = self.string;
        self.sx_font(font,[target rangeOfString:txt]);
        return self;
    };
}

- (NSMutableAttributedString * (^)(UIColor *_Nonnull, NSRange))sx_color {
    return ^(UIColor *color, NSRange range) {
        if (range.location + range.length > self.length) return self;
        [self addAttributes:@{NSForegroundColorAttributeName : color} range:range];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(UIColor * _Nonnull, NSString * _Nonnull))sx_color1 {
    return ^(UIColor *color, NSString *txt) {
        NSString *target = self.string;
        self.sx_color(color,[target rangeOfString:txt]);
        return self;
    };
}

@end
