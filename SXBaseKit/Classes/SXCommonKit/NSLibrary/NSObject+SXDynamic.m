//
//  NSObject+SXDynamic.m
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import "NSObject+SXDynamic.h"
#import <objc/runtime.h>

const char *k_sx_dynamic = "k_sx_dynamic_params";
@implementation NSObject (SXDynamic)

- (NSMutableDictionary *)sx_objectParams {
    NSMutableDictionary *params = objc_getAssociatedObject(self, k_sx_dynamic);
    if (params == nil) {
        params = @{}.mutableCopy;
        objc_setAssociatedObject(self, k_sx_dynamic, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return params;
}

- (void)sx_setObject:(id)object forKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) return;
    if (key.length == 0) return;
    [self sx_objectParams][key] = object;
}
- (id)sx_objectForKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) return nil;
    if (key.length == 0) return nil;
    return [self sx_objectParams][key];
    
}

@end


