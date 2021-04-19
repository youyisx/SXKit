//
//  UILabel+SXDynamic.h
//  VSocial
//
//  Created by vince_wang on 2021/3/10.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (SXDynamic)

+ (UILabel * (^)(NSString *_Nullable))sx_label;
- (UILabel * (^)(UIFont *_Nullable))sx_font;
- (UILabel * (^)(UIColor *_Nullable))sx_color;
- (UILabel * (^)(NSInteger))sx_lines;
- (UILabel * (^)(NSTextAlignment))sx_alignment;
- (void)sx_setLayoutPriorityDefaultHeight;
@end



NS_ASSUME_NONNULL_END
