//
//  UIView+SXHud.h
//  VSocial
//
//  Created by vince_wang on 2021/1/19.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SXHud)
@property (nonatomic ) NSString *sx_hudTips;
- (void)sx_hideHud;
- (void)sx_showHud;
- (void)sx_showHudWith:(nullable NSString *)tips;

- (void)sx_showTips:(NSString *)tips;

@end


NS_ASSUME_NONNULL_END
