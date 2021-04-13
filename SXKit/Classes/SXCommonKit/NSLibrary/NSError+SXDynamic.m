//
//  NSError+SXDynamic.m
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/3/10.
//  Copyright © 2021 vince. All rights reserved.
//

#import "NSError+SXDynamic.h"
#import "SXValidLibrary.h"
NSInteger const SXErrorCode = - 9527001;

@implementation NSError (SXDynamic)


+ (instancetype)sx_cocoaError:(NSString *)error{
    return [NSError sx_cocoaCode:SXErrorCode error:error];
}

+ (instancetype)sx_cocoaCode:(NSInteger)code
                       error:(NSString *)error{
    return  [NSError errorWithDomain:NSCocoaErrorDomain
                                code:code
                            userInfo:@{NSLocalizedDescriptionKey:sx_stringWithObject(error)}];
}

- (NSString *)sx_errorInfo{
    NSString *info_ = sx_stringInDictionaryForKey(self.userInfo, @"tips");
    if (!info_.length) info_ = sx_stringInDictionaryForKey(self.userInfo, NSLocalizedDescriptionKey);
    return info_;
}


@end
