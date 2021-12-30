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

@interface SXTableView : UITableView

@end
@implementation SXTableView

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    if (view && self.contentOffset.x <= 0) {
//        return nil;
//    }
//    NSLog(@"-- view %@",NSStringFromClass(view.class));
////    self.panGestureRecognizer.delegate = self;
//    return view;
//}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
//        NSLog(@"%s",__FUNCTION__);
//        @weakify(self);
//        [[RACObserve(self, contentOffset) distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
//            @strongify(self);
//            CGFloat py = self.contentOffset.y;
//            CGFloat offset = self.contentInset.top;
//            if (py + offset >= 0) return;
//            UIResponder * responder = self.nextResponder;
//            while (responder != nil && ![responder isKindOfClass:[UIViewController class]]) {
//                responder = responder.nextResponder;
//            }
//            if ([responder isKindOfClass:[UIViewController class]]) {
//                UIViewController *c = (UIViewController *)responder;
//                [c dismissViewControllerAnimated:YES completion:nil];
//            }
//        }];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        NSLog(@"%s",__FUNCTION__);
//    }
//    return self;
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint contentOffset       = self.contentOffset;
        CGPoint velocity            = [pan velocityInView:pan.view];
        //        CGAffineTransform transform = self.superview.transform;
        //        if (transform.ty != 0) {
        //            return NO;
        //        }
        if (contentOffset.y == -self.contentInset.top) {
            NSLog(@"%@", NSStringFromCGPoint(velocity));
            // 关键点: 当前是最顶点, 不允许往下滑动
            if (velocity.y > 0) {
                // 向下
                return NO;
            }
        }
    }
    return YES;
}

@end

@interface SXAlertView : UIView
@property (nonatomic, assign) BOOL ignore;
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

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *hitView = [super hitTest:point withEvent:event];
//    if (hitView == self || self.ignore) {
//        NSLog(@"-- nil");
//        return nil;
//    }
//    NSLog(@"--- other");
//    return hitView;
//}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}
@end

@interface SXAlertViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
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
//    self.view.layer.cornerRadius = 12;
    self.view.backgroundColor = [UIColor clearColor];
    
//    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
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
    
    self.tableView = [[SXTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.rowHeight = 40;
    self.tableView.estimatedRowHeight = 40;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.bottom.mas_equalTo(tf.mas_top);
        make.leading.trailing.mas_equalTo(0);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"-> %@",@(indexPath.row)];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= -scrollView.contentInset.top && scrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"tableview top");
        SXAlertView *view = (SXAlertView *)self.view;
        view.ignore = YES;
        scrollView.panGestureRecognizer.state = UIGestureRecognizerStateEnded;
        [scrollView setContentOffset:CGPointZero animated:NO];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            view.ignore = NO;
//        });
        return;
    }
}
@end
