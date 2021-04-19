//
//  UIView+SXHud.m
//  VSocial
//
//  Created by vince_wang on 2021/1/19.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIView+SXHud.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "NSObject+SXDynamic.h"
#define k_hud_0 @"k_hud_0"
#define k_hud_count @"k_hud_count"

@implementation UIView (SXHud)

@dynamic sx_hudTips;

- (void)setSx_hudTips:(NSString *)sx_hudTips {
    MBProgressHUD *hud_ = [self sx_objectForKey:k_hud_0];
    hud_.detailsLabel.text = sx_hudTips;
}

- (NSString *)sx_hudTips {
    MBProgressHUD *hud_ = [self sx_objectForKey:k_hud_0];
    return hud_.detailsLabel.text;
}

- (void)sx_hideHud {
    NSInteger hudCount = [[self sx_objectForKey:k_hud_count] integerValue];
    hudCount -= 1;
    if (hudCount <= 0){
        MBProgressHUD *hud_ = [self sx_objectForKey:k_hud_0];
        [hud_ hideAnimated:true];
        [self sx_setObject:nil forKey:k_hud_0];
        hudCount = 0;
    }
    [self sx_setObject:@(hudCount) forKey:k_hud_count];
}

- (void)sx_showHud {
    [self sx_showHudWith:nil];
}

- (void)sx_showHudWith:(NSString *)tips {
    NSInteger hudCount = [[self sx_objectForKey:k_hud_count] integerValue];
    hudCount += 1;
    [self sx_setObject:@(hudCount) forKey:k_hud_count];
    MBProgressHUD *hud_ = [self sx_objectForKey:k_hud_0];
    if (hud_ == nil) {
        hud_ = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [hud_ removeFromSuperViewOnHide];
        hud_.contentColor = [UIColor whiteColor];
        hud_.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud_.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self sx_setObject:hud_ forKey:k_hud_0];
    }
    hud_.detailsLabel.text = tips;
}

- (void)sx_showTips:(NSString *)tips {
    if (tips.length <= 0) return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = tips;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [hud hideAnimated:YES afterDelay:2.5];
    hud.userInteractionEnabled = NO;
}

@end

