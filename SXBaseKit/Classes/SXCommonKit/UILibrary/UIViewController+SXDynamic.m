//
//  UIViewController+SXDynamic.m
//  VSocial
//
//  Created by vince_wang on 2021/2/2.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIViewController+SXDynamic.h"
#import <Masonry/Masonry.h>
#import "SXCommonDefines.h"
@implementation UIViewController (SXDynamic)

- (void)sx_goBack {
    UIViewController *backController = self;
    if ([self isKindOfClass:[UINavigationController class]]) backController = [((UINavigationController *)self).viewControllers lastObject];
    if (backController.navigationController.viewControllers.count > 0) {
        UINavigationController *nc = backController.navigationController;
        NSArray *vcs = nc.viewControllers;
        if ([vcs containsObject:backController] && [vcs lastObject] != backController) {
            NSMutableArray *m_vcs = vcs.mutableCopy;
            [m_vcs removeObject:backController];
            [nc setViewControllers:m_vcs];
        } else {
            [backController.navigationController popViewControllerAnimated:YES];
        }
    } else {
        backController = backController.navigationController ? backController.navigationController : backController;
        [backController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIView *)sx_appBottomBar:(CGFloat)height {
    UIView *bottomBar = [UIView new];
    [self.view addSubview:bottomBar];
    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(SXSafeBottomHeight + height);
    }];
    return bottomBar;
}

@end

