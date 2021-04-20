//
//  NSString+SXURL.h
//  SXKit
//
//  Created by vince on 2021/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SXURL)
/// 往指定domain 域名的 http链接 追加参数
- (NSString *)sx_appendParamIfNeed:(NSDictionary <NSString *,NSString *>*)param domain:(nonnull NSString *)domain;
/// 获取链接中的参数
- (NSDictionary *)sx_URLParams;
/// 支付键值对直接取参数
- (NSString *)objectForKeyedSubscript:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
