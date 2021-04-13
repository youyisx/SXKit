//
//  UITextField+SXDynamic.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/2/24.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (SXDynamic)
/// 会修改delegate
- (void)sx_setMaxTextLength:(NSInteger)length;

- (UITextField * (^)(NSString *_Nullable,UIColor *_Nullable, UIFont *_Nullable))sx_placeholder;
@end

NS_ASSUME_NONNULL_END
