//
//  SXProgressLayer.h
//  WebTVPlayer
//
//  Created by 王浪 on 15/1/21.
//  Copyright (c) 2015年 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXProgress : UIView
@property(nonatomic,assign)CGFloat progress;
@property(nonatomic,assign)CGFloat downProgress;
@property(nonatomic) UIColor *progressColor;
@property(nonatomic) UIColor *downProgressColor;
@end

@interface SXProgressSlider : UIView
@property (nonatomic, strong) SXProgress *progress;
@property (nonatomic) CGFloat progressHeight;
@property (nonatomic, copy) dispatch_block_t willSeek;
@property (nonatomic, copy) dispatch_block_t endSeek;
@property (nonatomic, copy) void(^doSeek)(CGFloat seek);
@property (nonatomic, strong) UIView *point;
/// 0 ~1
- (CGFloat)seek:(CGFloat)seek;
@end
