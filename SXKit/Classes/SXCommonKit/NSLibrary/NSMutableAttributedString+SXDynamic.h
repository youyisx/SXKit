//
//  NSMutableAttributedString+SXDynamic.h
//  VSocial
//
//  Created by vince on 2021/3/11.
//  Copyright © 2021 vince. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (SXDynamic)

+ (NSMutableAttributedString * (^)(NSString *_Nullable))sx_str;
- (NSMutableAttributedString * (^)(UIFont *, NSRange))sx_font;
- (NSMutableAttributedString * (^)(UIFont *, NSString *))sx_font1;

- (NSMutableAttributedString * (^)(UIColor *, NSRange))sx_color;
- (NSMutableAttributedString * (^)(UIColor *, NSString *))sx_color1;

@end

NS_ASSUME_NONNULL_END
