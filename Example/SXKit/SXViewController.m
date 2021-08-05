//
//  SXViewController.m
//  SXKit
//
//  Created by vince_wang on 04/09/2021.
//  Copyright (c) 2021 vince_wang. All rights reserved.
//

#import "SXViewController.h"
#import <SXBaseKit/SXCommon.h>
#import <SXBaseKit/SXHudHeader.h>
//#import <SXKit/SXVodPlayer.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import <SXBaseKit/SXPickerContentView+DatePicker.h>
#import <SXBaseKit/SXPickerContentView+Picker.h>
#import <SXBaseKit/SXVideoTrimmerView.h>
#import "SXTableViewController.h"
//#import "SXModalPresentation.h"
#import <SXBaseKit/SXModalPresentation.h>
#import <SXBaseKit/SXApp.h>
#import <SXBaseKit/UIScrollView+SXStack.h>
@interface SXViewController ()
//@property (nonatomic, strong) SXVodControlPlayer *player;
@property (nonatomic, strong) UIView *testView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation SXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor greenColor];
//    SXVideoTrimmerView *mask = [[SXVideoTrimmerView alloc] initWithFrame:CGRectMake(10, 250, 320, 50)];
//    mask.backgroundColor = [UIColor redColor];
//    [self.view addSubview:mask];
//    mask.framesCount = 60;
//    mask.minIntervalProgress = 0.01;
//    mask.maxIntervalProgress = 0.02;
//    [mask activeTrimmerView];
//    for (int i = 0; i < mask.framesCount; i++) [mask setFrame:[UIImage imageNamed:@"test.jpg"] idx:i];
    
//    self.player = [SXVodControlPlayer new];
//    [self.view addSubview:self.player];
//    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
//        make.leading.trailing.mas_equalTo(0);
//        make.height.mas_equalTo(200);
//    }];
//    [self.player preparePlayWithUrl:@"http://img02-xusong.taihe.com/321669_db68904e275e00f07c988f62d9dc78ce_[640_360_5756].mp4"];
//    [self.player.cover sd_setImageWithURL:[NSURL URLWithString:@"https://img02-xusong.taihe.com/321669_4b95c20e38623c03c456ad2d22d4574b_[640_360_71].jpeg"]];
    
//    self.player.control.fullBtn.hidden = true;
//    self.player.control.pSlider.userInteractionEnabled = false;
//    [self.player.contentView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[UIPanGestureRecognizer class]]) {
//            obj.enabled = NO;
//        }
//    }];
    
//    NSLog(@"--- top:%@ bottom:%@",@(SXStatusBarHeight),@(SXSafeBottomHeight));
//
////    self.modalPresentationStyle
//
//    self.testView = UIView.sx_view(UIColor.clearColor);
//    [self.testView sx_addGradientBackLayerWithColors:@[UIColor.clearColor, UIColor.redColor] start:CGPointMake(0.5, 0) end:CGPointMake(0.5, 1)];
//    [self.view addSubview:self.testView];
//    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(40);
//        make.leading.mas_equalTo(40);
//        make.size.mas_equalTo(CGSizeMake(arc4random_uniform(200)+5, arc4random_uniform(200)+5));
//    }];
//
//    NSLog(@"-- %@",@([SXApp compareBuildVersion:@"2021052411"]));
//    NSLog(@"-- %@",@([SXApp compareBuildVersion:@"2.1.3"]));
//    NSLog(@"-- %@",@([SXApp compareBuildVersion:@"0.1.3"]));
//    NSLog(@"-- %@",@([SXApp compareBuildVersion:@"1.0.0.0"]));
//    NSLog(@"-- %@",@([SXApp compareBuildVersion:@"1.0.0.1"]));
    
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.leading.mas_equalTo(20);
        make.trailing.mas_equalTo(-20);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-100);
    }];
    self.scrollView = scrollView;
    self.scrollView.arrangedSubviews = @[
        [self _createView],
        [self _createView],
        [self _createView],
        [self _createView],
        [self _createView],
    ];
}

- (UIView *)_createView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
//    view.sx_stackEdge = UIEdgeInsetsMake(arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30));
    view.sx_stackHeight = arc4random_uniform(80)+20;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    @weakify(self)
    @weakify(view)
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        @strongify(view)
        NSInteger value = arc4random_uniform(3);
        if (value == 0) {
            [self.scrollView removeArrangedSubview:view];
        } else if (value == 1) {
//            view.sx_stackEdge = UIEdgeInsetsMake(arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30));
            view.sx_stackHeight = arc4random_uniform(80)+20;
        } else {
            NSInteger idx = [self.scrollView indexOfArrangeView:view];
            if (idx < 0) return;
            [self.scrollView insertArrangedSubview:[self _createView] atIndex:idx];
        }
    }];
    return view;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickedBtn:(id)sender {
//    [self.testView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(arc4random_uniform(200)+5, arc4random_uniform(200)+5));
//    }];
//    [SXPickerContentView showSources:@[@"1",@"2"] selected:^(NSInteger idx) {
//
//    }];
//    [SXPickerContentView showDatePicker:^(NSDate * _Nonnull date) {
//        NSLog(@"--date :%@",date);
//    }];
    SXTableViewController *vc = [SXTableViewController new];
//    SXModelPresentationVal *val = [SXModalPresentat]
    SXModelPresentationVal *val = [SXModelPresentationVal defaultVal];
    val.hidenWhenTouchMask = YES;
//    val.didHideBlock = ^{
//        NSLog(@"--- hidden");
//    };
    [SXModalPresentation presentationWithViewController:vc val:val completed:nil];
//    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    [self.navigationController pushViewController:vc animated:NO];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *item = [self _createView];
    [self.scrollView addArrangedSubview:item];
}

@end
