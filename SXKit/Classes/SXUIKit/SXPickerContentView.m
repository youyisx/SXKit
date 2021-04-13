//
//  SXPickerContentView.m
//  VSocial
//
//  Created by vince_wang on 2021/3/5.
//  Copyright © 2021 vince. All rights reserved.
//

#import "SXPickerContentView.h"
#import "SXNavigationHeader.h"
#import "SXCommon.h"
@interface SXPickerContentView()
@property (nonatomic, strong) UIView *pickerBackView;
@end
@implementation SXPickerContentView

+ (instancetype)showPicker:(UIView *)pickerVeiw confirm:(nonnull dispatch_block_t)confirm{
    UIView *window_ = SXRootWindow();
    SXPickerContentView *contentView = [[SXPickerContentView alloc] initWithFrame:window_.bounds];
    contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    [window_ addSubview:contentView];
    CGFloat height = 200;
    CGFloat backBarH = 40;
    CGFloat backHeight = height +SXSafeBottomHeight + backBarH;
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.sx_h, contentView.sx_w, backHeight)];
    back.backgroundColor = UIColor.whiteColor;
    contentView.pickerBackView = back;
    [contentView addSubview:back];
    
    UIButton *cancel = UIButton.sx_button(@"取消").sx_color(UIColor.grayColor).sx_font([UIFont systemFontOfSize:14]);
    cancel.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16);
    [cancel sizeToFit];
    [back addSubview:cancel];
    cancel.sx_h = backBarH;
    [cancel addTarget:contentView action:@selector(hidePicker) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sumit = UIButton.sx_button(@"确认").sx_color(UIColor.redColor).sx_font([UIFont systemFontOfSize:14 weight:UIFontWeightMedium]);
    sumit.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16);
    [sumit sizeToFit];
    [back addSubview:sumit];
    sumit.sx_h = backBarH;
    sumit.sx_x = back.sx_w - sumit.sx_w;
    @weakify(contentView)
    [[sumit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        !confirm?:confirm();
        [contentView hidePicker];
    }];
    
    pickerVeiw.frame = CGRectMake(0, backBarH, back.sx_w, height);
    [back addSubview:pickerVeiw];
    
    [contentView sx_tapAction:^{
        @strongify(contentView)
        [contentView hidePicker];
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, backBarH, back.sx_w, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4];
    [back addSubview:line];
    
    [UIView animateWithDuration:0.25 animations:^{
        back.sx_y = contentView.sx_h - backHeight;
    }];
    return contentView;
}

- (void)hidePicker {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBackView.sx_y = self.sx_h;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

