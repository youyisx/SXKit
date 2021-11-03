//
//  SXViewController.m
//  SXKit
//
//  Created by vince_wang on 04/09/2021.
//  Copyright (c) 2021 vince_wang. All rights reserved.
//

#import "SXViewController.h"
#import <SXBaseKit/SXCommon.h>
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
#import <objc/runtime.h>
#import <SXBaseKit/SXSimpleCollectionView.h>
#import <SXBaseKit/UIView+SXDynamic.h>
#import <SXBaseKit/UIImage+SXDynamic.h>
static void *my_a = &my_a;
static void *my_b = &my_b;

#import <SXBaseKit/SXCustomLogger.h>
#import <SXBaseKit/SXToastScheduler.h>

#import <MBProgressHUD/MBProgressHUD.h>
#import <SXBaseKit/SXPhotoPickerController.h>

#import "UIViewController+TransitioningTest.h"
@interface SXViewController ()
//@property (nonatomic, strong) SXVodControlPlayer *player;
@property (nonatomic, strong) SXSimpleCollectionView *collectionView;
@property (nonatomic, strong) RACChannel *channel;
@property (nonatomic, strong) RACSignal *queueSignal;
@property (nonatomic, strong) RACMulticastConnection *connection;

@property (nonatomic, strong) UIView *colorView;

@property (nonatomic, strong) UITextField *textField;
@end

@implementation SXViewController

- (void)clicked:(UIGestureRecognizer *)tap {
    NSLog(@"---> ??");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ABC";
    self.textField = [UITextField new];
    self.textField.layer.borderColor = UIColor.blackColor.CGColor;
    self.textField.layer.borderWidth = 1;
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
//    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
//    inputView.backgroundColor = [UIColor redColor];
//    self.textField.inputView = inputView;
    self.colorView = UIImageView.sx_view1(UIColor.redColor,CGRectMake(20, 200, 20, 20));
    self.colorView.transform = CGAffineTransformMakeScale(0.5, 0.8);
    UIImage *img = [UIImage sx_layerImageWithLayer:self.colorView.layer];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = UIColor.blueColor;
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTitle:@" 嘿嘿哈嘿" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];

    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom).offset(100);
        make.centerX.mas_equalTo(self.view);
    }];
    
 
    
    
    
    
//    if (img) {
//        [UIImageJPEGRepresentation(img, 1) writeToFile:@"/Users/taihe-imac-ios-01/Desktop/tt.jpg" atomically:YES];
//    }
//    [self.view addSubview:self.colorView];
//    [self.colorView sx_tapAction:^{
//        NSLog(@"---> 点击 block");
//    }];
//    [[self.colorView sx_tapGesture] addTarget:self action:@selector(clicked:)];
    
    
    
    
//    UILabel *label = UILabel.sx_label(nil).sx_color(UIColor.redColor).sx_font([UIFont systemFontOfSize:18 weight:UIFontWeightBold]);
//    //中划线
//    NSDictionary *attribtDic1 = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    NSMutableAttributedString *attribtStr1 = [[NSMutableAttributedString alloc]initWithString:@"￥100元" attributes:attribtDic1];
//    [attribtStr1 appendAttributedString:[[NSAttributedString alloc] initWithString:@"RMB" attributes:@{NSBaselineOffsetAttributeName:@(10)}] ];
//    label.attributedText = attribtStr1;
//    [self.view addSubview:label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(self.view).centerOffset(CGPointMake(0, -10));
//    }];
    
//    MBProgressHUD *hud_ = [self sx_objectForKey:k_hud_0];
//    if (hud_ == nil) {
//        hud_ = [MBProgressHUD showHUDAddedTo:self animated:YES];
//        [hud_ removeFromSuperViewOnHide];
//        hud_.contentColor = [UIColor whiteColor];
//        hud_.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//        hud_.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
//        [self sx_setObject:hud_ forKey:k_hud_0];
//    }
//    hud_.detailsLabel.text = tips;
    
    SXToastScheduler.share.toaskShowConfiguration = ^(NSString * _Nonnull title, NSDictionary * _Nullable info, UIView * _Nonnull contentView, dispatch_block_t  _Nonnull completed) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:contentView ? contentView : SXRootWindow() animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = title;
        hud.contentColor = [UIColor whiteColor];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [hud hideAnimated:YES afterDelay:2.5];
        hud.userInteractionEnabled = NO;
        hud.completionBlock = completed;
    };
    SXToastScheduler.share.oneByOne = YES;
    SXToastScheduler.share.ignoreSameToast = NO;
//    SXCustomLogger.showLevel = SXCustomLogLevelWarn | SXCustomLogLevelInfo;
//    UIImage *bigImg = [UIImage imageNamed:@"112.jpeg"];
//
//    [[bigImg sx_compressWithMaxDataSizeKBytes:20 * 1024] writeToFile:@"/Users/taihe-imac-ios-01/Desktop/11.jpg" atomically:YES];
//    SXCLog(@"aa");
//    SXCLogInfo(@"info,");
//    SXCLogWarn(@"warn,");
//    SXCLogInfo(@"fff,%@ %@",@(111),@"aaa");
//    SXCLogWarn(@"fff,%@ %@",@(111),@"aaa");
//    SXCLog(@"aaa,%@",@"a");
//    SXCLog(nil);
    
//    SXCLevelLog(SXCustomLogLevelWarn|SXCustomLogLevelInfo, @"噢咕噜 %@",@"12");

    
    
    
    
//    [list removeObjectAtIndex:[list indexOfObject:@""]];
    
//    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//    layout.minimumLineSpacing = 20;
//    layout.minimumInteritemSpacing = 20;
//    layout.itemSize = CGSizeMake(240, 120);
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.sectionInset = UIEdgeInsetsMake(0, 75, 0, 75);
//    self.collectionView =[SXSimpleCollectionView simpleWithLayout:layout cell:NSStringFromClass(UICollectionViewCell.class)];
//
//    self.collectionView.sx_pagingEnabled = YES;
//    [self.view addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.view);
//        make.leading.trailing.mas_equalTo(0);
//        make.height.mas_equalTo(160);
//    }];
//    self.collectionView.backgroundColor = [UIColor greenColor];
//
//    NSMutableArray *sources = @[].mutableCopy;
//    for (int i = 0; i<50; i++) {
//        [sources addObject:@(i)];
//    }
//    self.collectionView.sources = sources;
    
    
//    [self.view sx_addBottomLine:2 color:UIColor.redColor edge:UIEdgeInsetsMake(0, 20, 20, 20)];
//    [self.view sx_removeBottomLine];
//    SXAppDelegate()
   
    
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
    
//
//    UIScrollView *scrollView = [UIScrollView new];
//    scrollView.animationDuration = 0.25;
//    scrollView.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:scrollView];
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
//        make.leading.mas_equalTo(20);
//        make.trailing.mas_equalTo(-20);
//        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).offset(-100);
//    }];
//    self.scrollView = scrollView;
//    self.scrollView.arrangedSubviews = @[
//        [self _createView],
//        [self _createView],
//        [self _createView],
//        [self _createView],
//        [self _createView],
//    ];
}

- (UIView *)_createView {
//    UIView *view = [UIView new];
//    view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
//    view.sx_stackEdge = UIEdgeInsetsMake(arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30));
//    view.sx_stackHeight = arc4random_uniform(80)+20;
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundColor = [UIColor whiteColor];
//    [btn setTitle:@"X" forState:UIControlStateNormal];
//    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
//    [view addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.trailing.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(30, 20));
//    }];
//    @weakify(self)
//    @weakify(view)
//    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        @strongify(self)
//        @strongify(view)
//        NSInteger value = arc4random_uniform(3);
//        value = 0;
//        if (value == 0) {
//            [self.scrollView removeArrangedSubview:view];
//        } else if (value == 1) {
////            view.sx_stackEdge = UIEdgeInsetsMake(arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30), arc4random_uniform(30));
//            view.sx_stackHeight = arc4random_uniform(80)+20;
//        } else {
//            NSInteger idx = [self.scrollView indexOfArrangeView:view];
//            if (idx < 0) return;
//            [self.scrollView insertArrangedSubview:[self _createView] atIndex:idx];
//        }
//    }];
//    return view;
    return nil;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickedBtn:(id)sender {
    [self openAlert];
    
//    [self.testView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(arc4random_uniform(200)+5, arc4random_uniform(200)+5));
//    }];
//    [SXPickerContentView showSources:@[@"1",@"2"] selected:^(NSInteger idx) {
//
//    }];
//    [SXPickerContentView showDatePicker:^(NSDate * _Nonnull date) {
//        NSLog(@"--date :%@",date);
////    }];
//    SXTableViewController *vc = [SXTableViewController new];
////    SXModelPresentationVal *val = [SXModalPresentat]
//    SXModelPresentationVal *val = [SXModelPresentationVal defaultVal];
//    val.hidenWhenTouchMask = YES;
////    val.didHideBlock = ^{
////        NSLog(@"--- hidden");
////    };
//    [SXModalPresentation presentationWithViewController:vc val:val completed:nil];
////    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
////    [self.navigationController pushViewController:vc animated:NO];
////    [self.navigationController presentViewController:vc animated:YES completion:nil];
////    [self.navigationController pushViewController:vc animated:NO];
//    SXPhotoPickerController *picker = [SXPhotoPickerController defaultPickerController];
//    picker.selectedIdx = 1;
//    picker.maxSelectedCount = 3;
//    picker.selectCallBack = ^(NSArray<PHAsset *> * list) {
//        SXCLogInfo(@"%@",list);
//    };
//    [self presentViewController:picker animated:YES completion:nil];
}

- (void)test {
    NSLog(@"%s",__FUNCTION__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
//    NSString *tips = @" [self.navigationController pushViewController:vc animated:NO];地地中国地中地中地国地国地国地f[self.navigationController pushViewController:vc animated:NO];地地中国地中地中地国地国地国地f[self.navigationController pushViewController:vc animated:NO];地地中国地中地中地国地国地国地f[self.navigationController pushViewController:vc animated:NO];地地中国地中地中地国地国地国地f";
//    UILabel *tipsLabel = [UILabel new];
//    tipsLabel.numberOfLines = 0;
//    tipsLabel.text = tips;
//    tipsLabel.textColor = UIColor.redColor;
//    tipsLabel.font = [UIFont systemFontOfSize:12];
//    CGSize size = [tipsLabel sizeThatFits:CGSizeMake(100, CGFLOAT_MAX)];
  
    
//
//    NSInteger length = phone.length;
//    NSString *last = phone.length > 7 ? [phone substringFromIndex:7] : nil;
//    NSString *mid  = phone.length > 3 ? [phone substringWithRange:NSMakeRange(3, (length - 3) > 4 ? 4 : (length - 3))] : nil;
//    NSString *first = phone.length > 3 ? [phone substringToIndex:3] : phone;
//    NSLog(@"%@-%@-%@",first,mid,last);
    
    [UIView animateWithDuration:0.45 animations:^{
//        if (arc4random_uniform(2) == 0) {
//            self.colorView.sx_extendToTop -= arc4random_uniform(50)+5;
//        } else {
//            self.colorView.sx_extendToTop += arc4random_uniform(50)+5;
//        }
        self.colorView.sx_y = self.colorView.sx_centerTopInSuperview;
        self.colorView.sx_x = self.colorView.sx_centerLeftInSuperView;
    }];
//    [self.colorView sx_tapAction]
    
//    static int t = 0;
//    t++;
//    int a = 1;
//    if (a) {
//        [SXToastScheduler.share toast:@(t).stringValue info:@{@"a":@"b"} inView:self.view];
//    } else {
//        [SXToastScheduler.share removeAll];
//    }
}

@end
