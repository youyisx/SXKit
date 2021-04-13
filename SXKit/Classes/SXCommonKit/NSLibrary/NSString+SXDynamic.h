//
//  NSString+SXDynamic.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/2/5.
//  Copyright © 2021 vince. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SXDynamic)

- (NSAttributedString *)sx_attrs:(nullable NSDictionary<NSAttributedStringKey, id> *)attrs;

- (BOOL)sx_isPhoneNumber;

@end





NS_ASSUME_NONNULL_END
