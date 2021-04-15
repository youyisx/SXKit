//
//  NSString+SXEncrypt.m
//  SXKit
//
//  Created by taihe-imac-ios-01 on 2021/4/15.
//

#import "NSString+SXEncrypt.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (SXEncrypt)

- (NSString *)sx_md5;
{
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}

@end
