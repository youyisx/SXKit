//
//  NSString+SXDynamic.m
//  VSocial
//
//  Created by vince_wang on 2021/2/5.
//  Copyright © 2021 vince. All rights reserved.
//

#import "NSString+SXDynamic.h"

@implementation NSString (SXDynamic)
#pragma mark --- 文本相关
- (NSAttributedString *)sx_attrs:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    return [[NSAttributedString alloc] initWithString:self attributes:attrs];
}

- (CGSize)sx_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    return [self boundingRectWithSize:maxSize
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName : font} context:nil].size;
}

#pragma mark - 正则相关
/// 校验国内运营商手机号码
- (BOOL)sx_isCNPhoneNumber {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,183,184,178
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181,177
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|70|8[0-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,183,184,178
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|78|8[2-478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,176
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|76|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189,177
     22         */
    NSString * CT = @"^1((33|53|77|8[019])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
//    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    if (([self sx_isValidateByRegex:MOBILE] == YES)
        || ([self sx_isValidateByRegex:CM] == YES)
        || ([self sx_isValidateByRegex:CU] == YES)
        || ([self sx_isValidateByRegex:CT] == YES))    return YES;
    return NO;
}

//邮箱
- (BOOL)sx_isEmailAddress{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self sx_isValidateByRegex:emailRegex];
}

//身份证号
- (BOOL)sx_isCNIDCardNum{
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    return [self sx_isValidateByRegex:regex2];
}

- (BOOL)sx_isValidateByRegex:(NSString *)regex{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}

#pragma mark --- 其它

- (void)sx_preCapital:(BOOL *)pre
              capital:(BOOL *)capital
               letter:(BOOL *)letter
                  num:(BOOL *)num
                   zh:(BOOL *)zh
               symbol:(BOOL *)symbol{
    NSInteger alength = [self length];
    (*pre) = NO;
    (*capital) = NO;
    (*letter) = NO;
    (*num) = NO;
    (*zh) = NO;
    (*symbol) = NO;
    for (int i = 0; i<alength; i++) {
        char commitChar = [self characterAtIndex:i];
        NSString *temp = [self substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if (3==strlen(u8Temp)){
            (*zh) = YES;
        }else if((commitChar>64)&&(commitChar<91)){
            (*capital) = YES;
            if (i == 0) (*pre) = YES;
        }else if((commitChar>96)&&(commitChar<123)){
            (*letter) = YES;
        }else if((commitChar>47)&&(commitChar<58)){
            (*num) = YES;
        } else {
            (*symbol) = YES;
        }
    }
}

/// 判断是否为纯数字
- (BOOL)sx_isPureInt {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

/// 判断是否为浮点型
- (BOOL)sx_isPureFloat {
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

@end
