//
//  NSDictionary+SXDynamic.m
//  SXKit
//
//  Created by taihe-imac-ios-01 on 2021/4/9.
//

#import "NSDictionary+SXDynamic.h"

@implementation NSDictionary (SXDynamic)
- (BOOL)sx_containsObjectForKey:(id)key {
    if (!key) return NO;
    return self[key] != nil;
}
@end
