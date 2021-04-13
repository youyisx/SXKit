//
//  UIView+SXAlert.h
//  VSocial
//
//  Created by vince on 2021/3/16.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SXAlert)
@property (nonatomic) UIButton *_Nullable sx_alertBack;
/// 0 从中间出现 消息 1 从底部出现消失
@property (nonatomic) NSInteger sx_alertPosition;
@property (nonatomic) BOOL sx_hideWhenTouchBack;
@property (nonatomic) dispatch_block_t sx_hideCompleted;
- (void)sx_alertShow;
- (void)sx_alertHide;
- (void)sx_alertHideWithCompleted:(dispatch_block_t _Nullable)completed;
@end

NS_ASSUME_NONNULL_END
