//
//  NSString+SXURL.m
//  SXKit
//
//  Created by vince on 2021/4/15.
//

#import "NSString+SXURL.h"
#import <objc/runtime.h>
@implementation NSString (SXURL)

- (NSString *)sx_appendParamIfNeed:(NSDictionary <NSString *,NSString *>*)param domain:(nonnull NSString *)domain {
    if (param.count == 0) return self;
    NSURL *url = [NSURL URLWithString:self];
    if (url == nil) return self;
    if (domain.length == 0 || [url.host rangeOfString:domain].length == 0) return self;
    NSMutableArray <NSString *>*sortKeys = @[].mutableCopy;
    NSMutableDictionary <NSString *,NSString *>*queryParams = @{}.mutableCopy;
    NSMutableDictionary <NSString *,NSString *>*appendParam = param.mutableCopy;
    
    NSString *queryStr = [url query];
    NSArray *queryStrs = [queryStr componentsSeparatedByString:@"&"];
    
    for (NSString *q in queryStrs) {
        NSArray *qs = [q componentsSeparatedByString:@"="];
        if (qs.count == 0) continue;
        NSString *key = [qs firstObject];
        [sortKeys addObject:key];
        NSString *value = nil;
        if (qs.count == 2) {
            value = [qs lastObject];
        } else if (qs.count > 2) {
            NSMutableArray *mqs = qs.mutableCopy;
            [mqs removeObjectAtIndex:0];
            value = [mqs componentsJoinedByString:@"="];
        }
        if (value == nil) value = @"";
        queryParams[key] = value;
        if (value.length) appendParam[key] = nil;
    }
    [queryParams addEntriesFromDictionary:appendParam];
    __block NSString *appendQueryStr = @"";
    for (NSString *key in sortKeys) {
        NSString *value = queryParams[key];
        if (value == nil) value = @"";
        if (appendQueryStr.length > 0) appendQueryStr = [appendQueryStr stringByAppendingString:@"&"];
        appendQueryStr = [appendQueryStr stringByAppendingFormat:@"%@=%@",key,value];
        queryParams[key] = nil;
    }
    [queryParams enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (appendQueryStr.length > 0) appendQueryStr = [appendQueryStr stringByAppendingString:@"&"];
        appendQueryStr = [appendQueryStr stringByAppendingFormat:@"%@=%@",key,obj];
    }];
    if (appendQueryStr.length == 0) return self;
    NSString *result = self;
    if (queryStr.length == 0) {
        if (![result hasSuffix:@"?"]) result = [result stringByAppendingString:@"?"];
        result = [result stringByAppendingString:appendQueryStr];
    } else {
        result = [result stringByReplacingOccurrencesOfString:queryStr withString:appendQueryStr];
    }
    return result;
}

- (NSDictionary *)sx_URLParams {
    if (self.length == 0) return nil;
    
    NSURL *url = [NSURL URLWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSArray *components = [url.query componentsSeparatedByString:@"&"];
    if (components.count == 0) return nil;
    
    NSMutableDictionary *params = @{}.mutableCopy;
    for (NSString *str in components) {
        NSArray *subComponents = [str componentsSeparatedByString:@"="];
        if (subComponents.count != 2) continue;
        NSString *key = subComponents[0];
        NSString *value = subComponents[1];
        if (!key || !value) continue;
        params[key] = [value stringByRemovingPercentEncoding];
    }
    return params;
}

- (NSString *)objectForKeyedSubscript:(NSString *)key {
    NSDictionary *params = objc_getAssociatedObject(self, @selector(sx_URLParams));
    BOOL anyParams = YES;
    if (!params) {
        params = [self sx_URLParams];
        anyParams = NO;
    }
    
    if (!params || params.count == 0) return nil;
    
    if (!anyParams) objc_setAssociatedObject(self, @selector(sx_URLParams), params, OBJC_ASSOCIATION_RETAIN);
    return params[key];
}
@end
