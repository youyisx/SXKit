//
//  NSError+SXDynamic.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/3/10.
//  Copyright © 2021 vince. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSInteger const SXErrorCode;

NS_ASSUME_NONNULL_BEGIN

@interface NSError (SXDynamic)

+ (instancetype)sx_cocoaError:(NSString *)error;

+ (instancetype)sx_cocoaCode:(NSInteger)code
                       error:(NSString *)error;

- (NSString *)sx_errorInfo;

@end

NS_ASSUME_NONNULL_END
