//
//  SXAlertViewController.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/10/29.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "SXAlertViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "UIViewController+SXTransitioning.h"

@interface SXAlertView : UIView

@end
@implementation SXAlertView

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"%s",__FUNCTION__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self endEditing:NO];
//    UIView *child = [self viewWithTag:101];
//    if (child) {
//        [child removeFromSuperview];
//        return;
//    }
//    child = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
//    child.tag = 101;
//    child.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
//    [self addSubview:child];
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}
@end

@interface SXAlertViewController ()

@end

@implementation SXAlertViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    NSLog(@"%s",__FUNCTION__);
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    NSLog(@"%s",__FUNCTION__);
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    NSLog(@"%s",__FUNCTION__);
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    NSLog(@"%s",__FUNCTION__);
//}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"%s %@ %@",__FUNCTION__,self, NSStringFromCGRect(self.view.frame));
}

- (void)loadView {
    self.view = [[SXAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 12;
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    
    [self.view addSubview:confirm];
    [confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    @weakify(self);
    [[confirm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBtn setTitle:@"PUSH" forState:UIControlStateNormal];
    [pushBtn setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [self.view addSubview:pushBtn];
    [pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(confirm.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    [[pushBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.navigationController == nil) {
//            [self openAlertView];
            UIViewController *vc = [SXAlertViewController new];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
//            UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            [self.navigationController pushViewController:[SXAlertViewController new] animated:YES];
        }
    }];
    
    UITextField *tf = [UITextField new];
    tf.layer.borderColor = UIColor.blackColor.CGColor;
    tf.layer.borderWidth = 1;
    [self.view addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).offset(-40);
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
        make.height.mas_equalTo(@40);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
