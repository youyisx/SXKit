//
//  SXVodPlayer.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/1/20.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXProgress.h"
#import <ReactiveObjC/ReactiveObjC.h>
/// 引入<SXKit/SXPhotoLibrary> 库后会自动在在Proprocessor Macros 中定义“SXPHOTOKIT”宏
#ifdef SXPHOTOKIT
#import "SXPhotoLibrary.h"
#endif
NS_ASSUME_NONNULL_BEGIN

/**
 * 1.4 画面填充模式
 */
typedef NS_ENUM(NSInteger, SXVodPlayerRenderMode) {
    SXVodPlayerRenderMode_SCREEN    = 0,    ///< 图像铺满屏幕，不留黑边，如果图像宽高比不同于屏幕宽高比，部分画面内容会被裁剪掉。
    SXVodPlayerRenderMode_EDGE      = 1,    ///< 图像适应屏幕，保持画面完整，但如果图像宽高比不同于屏幕宽高比，会有黑边的存在。
};

typedef NS_ENUM(NSInteger, SXVodPlayEvent) {
    SXVodPlayEvent_UnKnow = 0 ,
    /// 首帧加载回调
    SXVodPlayEvent_FirstIFrame = 1,
    /// 播放准备就绪
    SXVodPlayEvent_Prepared = 2,
    /// 播放结束
    SXVodPlayEvent_PlayEnd = 3,
};

@interface SXPlayerContentView : UIView
@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UIImageView *pauseIcon;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UIView *control;
@end

@interface SXVodPlayer : UIView
/// 播放层
@property (nonatomic, strong) SXPlayerContentView *contentView;
/// 准备播放
- (void)preparePlayWithUrl:(NSString *)url;
- (void)preparePlayWithUrl:(NSString *)url renderMode:(SXVodPlayerRenderMode)mode;
/// 播放（需主动调用 才会播放）
- (void)play;
- (void)pause;
- (void)resume;
- (void)stop;
- (BOOL)isPlaying;

#ifdef SXPHOTOKIT
/// 加载媒体资源
- (void)prepareLoadPHAsset:(PHAsset *)asset;
#endif

@property (nonatomic, copy) void(^eventCallBack)(SXVodPlayEvent);
/// 分辨率
@property (nonatomic, assign) CGSize resolution;
///播放进度
@property (nonatomic, assign) CGFloat progress;
/// 加载进度
@property (nonatomic, assign) CGFloat playable;
/// 时长
@property (nonatomic, assign) CGFloat duration;

+ (RACSignal <NSNumber *>*)asyncVideoCacheFileSize ;
+ (RACSignal *)asyncVideoClearCache ;

@end

@interface SXVodPlayerControl : UIView
@property (nonatomic, strong) SXProgressSlider *pSlider;
@property (nonatomic, strong) UIButton *fullBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSTimer *hideTimer;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *pLabel;
@end

/// 播放放器旋转通知
FOUNDATION_EXTERN NSString *const SXVodPlayerRotationNotificationName;

@interface SXVodControlPlayer : SXVodPlayer
@property (nonatomic, strong)SXVodPlayerControl *control;
@property (nonatomic, strong) UILabel *centerTimeLabel;
@end

NS_ASSUME_NONNULL_END
