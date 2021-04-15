//
//  NSString+SXDynamic.h
//  VSocial
//
//  Created by vince_wang on 2021/2/5.
//  Copyright © 2021 vince. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SXDynamic)

- (NSAttributedString *)sx_attrs:(nullable NSDictionary<NSAttributedStringKey, id> *)attrs;
/// 计算文本长度
- (CGSize)sx_sizeWithFont:(UIFont *)font
                  maxSize:(CGSize)maxSize;

/// 校验国内运营商手机号码
- (BOOL)sx_isCNPhoneNumber;
/// 邮箱
- (BOOL)sx_isEmailAddress;
/// 身份证号
- (BOOL)sx_isCNIDCardNum;
/// 正则校验
- (BOOL)sx_isValidateByRegex:(NSString *)regex;

/**
 校验字符串是否包含大小写字母，数字，中文，符号
 @param pre 首字母是否大写
 @param capital 是否包含大写字母
 @param letter 是否包含小写字母
 @param num 是否包含数字
 @param zh 是否包含中文
 @param symbol 是否包含符号
 */
- (void)sx_preCapital:(nullable BOOL *)pre
              capital:(nullable BOOL *)capital
               letter:(nullable BOOL *)letter
                  num:(nullable BOOL *)num
                   zh:(nullable BOOL *)zh
               symbol:(nullable BOOL *)symbol;
@end





NS_ASSUME_NONNULL_END
