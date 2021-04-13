//
//  SXVodPlayer.m
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/1/20.
//  Copyright © 2021 vince. All rights reserved.
//

#import "SXVodPlayer.h"
#import <TXLiteAVSDK_Player/TXVodPlayer.h>
#import "SXCommon.h"

NS_INLINE NSString * _SXVodPlayerTime(NSInteger second) {
    return [NSString stringWithFormat:@"%02ld:%02ld",second/60,second%60];
}

@implementation SXPlayerContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self configUI];
    return self;
}

- (void)configUI {
    self.backgroundColor = UIColor.blackColor;
    self.coverImgView = [UIImageView new];
    self.coverImgView.clipsToBounds = YES;
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.coverImgView.backgroundColor = UIColor.blackColor;
    [self addSubview:self.coverImgView];
    
    self.pauseIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sx_icon_play"]];
    self.pauseIcon.userInteractionEnabled = false;
    [self addSubview:self.pauseIcon];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loadingView.hidesWhenStopped = YES;
    [self addSubview:self.loadingView];
}

- (void)insertControl:(UIView *)view {
    [self.control removeFromSuperview];
    if (![view isKindOfClass:[UIView class]]) return;
    self.control = view;
    self.control.backgroundColor = [UIColor clearColor];
    [self insertSubview:self.control atIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat totalH = CGRectGetHeight(self.bounds);
    CGFloat totalW = CGRectGetWidth(self.bounds);
    
    self.coverImgView.frame = self.bounds;
    CGPoint center = CGPointMake(totalW * 0.5, totalH*0.5);
    self.pauseIcon.center = center;
    self.loadingView.center = center;
    
    
    self.control.frame = self.bounds;
}

@end

@interface SXVodPlayer()<TXVodPlayListener>
@property (nonatomic, strong) TXVodPlayer *vodPlayer;
/// 是否允许播放(外部调用播放play，pause,stop可以控制该字段)
@property (nonatomic, assign) BOOL allowPlay;
#ifdef SXPHOTOKIT
@property (nonatomic, strong) PHAsset *videoAsset;
#endif
@property (nonatomic, copy) NSString *videoUrl;

/// 是否允许启动控制操作
@property (nonatomic, assign) BOOL allowControl;
@end

@implementation SXVodPlayer
@dynamic cover;

- (void)dealloc {
    [self stop];
    self.vodPlayer.vodDelegate = nil;
    [self.vodPlayer removeVideoWidget];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configPlayer];
        [self configEvents];
    }
    return self;
}

- (void)configPlayer {
    self.contentView = [[SXPlayerContentView alloc] initWithFrame:self.bounds];
    [self addSubview:self.contentView];
    
    self.vodPlayer = [SXVodPlayer commonVodPlayer];
    self.vodPlayer.isAutoPlay = NO;
    self.vodPlayer.loop = NO;
    self.vodPlayer.vodDelegate = self;
    [self.vodPlayer setupVideoWidget:self.contentView insertIndex:0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.contentView.superview != self) return;
    self.contentView.frame = self.bounds;
}

- (void)configEvents {
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)];
    [self.contentView addGestureRecognizer:tapgesture];
    @weakify(self)
    __block BOOL needResume = NO;
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
       @strongify(self)
        if (needResume == YES) [self resume];
    }];
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable x) {
       @strongify(self)
        needResume = [self isPlaying];
        if (needResume == YES) [self pause];
    }];
}

- (UIImageView *)cover {
    return self.contentView.coverImgView;
}

#pragma mark --- event

- (BOOL)isPlaying {
    return [self.vodPlayer isPlaying];
}

- (void)resume {
    self.allowPlay = YES;
#ifdef SXPHOTOKIT
    if (self.videoUrl == nil && self.videoAsset) {
        [self _preparePlayPHAsset:self.videoAsset];
    } else {
        [self.vodPlayer resume];
    }
#else
    [self.vodPlayer resume];
#endif
    self.contentView.pauseIcon.alpha = 0;
    self.allowControl = YES;
}

- (void)pause {
    self.allowPlay = NO;
    [self.vodPlayer pause];
    self.contentView.pauseIcon.alpha = 1.0;
}

- (void)stop {
    [self.vodPlayer stopPlay];
#ifdef SXPHOTOKIT
    self.videoAsset = nil;
#endif
    self.videoUrl = nil;
    self.contentView.pauseIcon.alpha = 1.0;
    self.allowControl = NO;
    self.cover.hidden = NO;

}

- (void)play {
    if (self.allowPlay == false) [self.vodPlayer seek:0];
    [self resume];
}

- (void)toggle {
    if ([self isPlaying]) {
        [self pause];
    } else {
        [self resume];
    }
}

- (void)preparePlayWithUrl:(NSString *)url {
    [self preparePlayWithUrl:url renderMode:SXVodPlayerRenderMode_EDGE];
}

- (void)preparePlayWithUrl:(NSString *)url renderMode:(SXVodPlayerRenderMode)mode {
    [self stop];
    if (sx_stringWithObject(url).length == 0) return;
    self.videoUrl = sx_stringWithObject(url);
    [self.contentView.loadingView startAnimating];
    [self.vodPlayer setRenderMode:mode == SXVodPlayerRenderMode_SCREEN ? RENDER_MODE_FILL_SCREEN : RENDER_MODE_FILL_EDGE];
    [self.vodPlayer startPlay:self.videoUrl];
}

#ifdef SXPHOTOKIT
- (void)prepareLoadPHAsset:(PHAsset *)asset {
    [self stop];
    self.videoAsset = asset;
}

- (void)_preparePlayPHAsset:(PHAsset *)asset {
    [self stop];
    [self.contentView.loadingView startAnimating];
    @weakify(self)
    [SXPhotoHelper saveLocalVideoWithAsset:asset result:^(NSString * _Nonnull path, NSString *key) {
        @strongify(self)
        if (self.videoAsset == nil || ![key isEqual:self.videoAsset.localIdentifier]) return;
        self.videoUrl = path;
        [self.vodPlayer startPlay:path];
    }];
}
#endif
#pragma mark --- TXVodPlayListener
- (void)onPlayEvent:(TXVodPlayer *)player event:(int)EvtID withParam:(NSDictionary *)param {
    if (EvtID == PLAY_EVT_RCV_FIRST_I_FRAME) {
        // 首帧加载出来了
        [self.contentView.loadingView stopAnimating];
        self.cover.hidden = YES;
        !self.eventCallBack?:self.eventCallBack(SXVodPlayEvent_FirstIFrame);
    } else if (EvtID == PLAY_EVT_CHANGE_RESOLUTION) {
        // 分辨率发生改变
        CGFloat width = [sx_numberInDictionaryForKey(param, EVT_PARAM1) doubleValue];
        CGFloat height = [sx_numberInDictionaryForKey(param, EVT_PARAM2) doubleValue];
        self.resolution = CGSizeMake(width, height);
    } else if (EvtID == PLAY_EVT_VOD_PLAY_PREPARED) {
        /// 准备好了
        [self.contentView.loadingView stopAnimating];
        if (self.allowPlay == YES) { [self resume];};
        !self.eventCallBack?:self.eventCallBack(SXVodPlayEvent_Prepared);
    } else if (EvtID == PLAY_EVT_PLAY_PROGRESS) {
        self.playable = [sx_numberInDictionaryForKey(param, EVT_PLAYABLE_DURATION) doubleValue];
        self.duration = [sx_numberInDictionaryForKey(param, EVT_PLAY_DURATION) doubleValue];
        self.progress = [sx_numberInDictionaryForKey(param, EVT_PLAY_PROGRESS) doubleValue];
    } else if (EvtID == PLAY_EVT_PLAY_END) {
        !self.eventCallBack?:self.eventCallBack(SXVodPlayEvent_PlayEnd);
        if (player.loop == NO) { [self pause]; }
    } else if (EvtID == EVT_VOD_PLAY_LOADING_END) {
        [self.contentView.loadingView stopAnimating];
    } else if (EvtID == EVT_VIDEO_PLAY_LOADING) {
        [self.contentView.loadingView startAnimating];
    }

}

- (void)onNetStatus:(TXVodPlayer *)player withParam:(NSDictionary *)param {
    
}

#pragma mark ---

+ (TXVodPlayer *)commonVodPlayer {
    TXVodPlayer *player = [[TXVodPlayer alloc] init];
    player.enableHWAcceleration = YES;
    TXVodPlayConfig *cfg = [player config];
    if (!cfg) cfg = [TXVodPlayConfig new];
    cfg.cacheFolderPath = [self videoCachePath];
    cfg.maxCacheItems = 10;
    player.config = cfg;
    [player setRenderMode:RENDER_MODE_FILL_EDGE];
    return player;
}

+ (NSString *)videoCachePath {
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/txvodcache"];
}

#pragma mark --- private
+ (CGFloat)_fileSize:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) return 0;
    CGFloat size = 0;
    NSError *error = nil;
    NSDictionary *dic = [manager attributesOfItemAtPath:path error:&error];
    if (error == nil && dic) size = [dic[NSFileSize] doubleValue];
    return size/1024/1024;
}


+ (CGFloat)_videoCacheFileSize {
    NSString *path = [self videoCachePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) return 0;
    CGFloat fileSize = 0;
    NSArray <NSString *>*subPaths = [manager subpathsAtPath:path];
    for (NSString *file in subPaths) {
        NSString *filePath = [path stringByAppendingPathComponent:file];
        fileSize += [self _fileSize:filePath];
    }
    return fileSize;
}

+ (void)_videoClearCache {
    NSString *path = [self videoCachePath];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) return;
    NSError *error = nil;
    BOOL result = [manager removeItemAtPath:path error:&error];
    NSLog(@"视频缓存清除%@ %@",result == YES ? @"成功" : @"失败", error);
}

+ (void)_deleteFile:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) return;
    [manager removeItemAtPath:path error:nil];
}
#pragma mark --- public

+ (RACSignal <NSNumber *>*)asyncVideoCacheFileSize {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CGFloat size = [self _videoCacheFileSize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [subscriber sendNext:@(size)];
                [subscriber sendCompleted];
            });
        });
        return nil;
    }];
}

+ (RACSignal *)asyncVideoClearCache {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self _videoClearCache];
            dispatch_async(dispatch_get_main_queue(), ^{
                [subscriber sendNext:@(1)];
                [subscriber sendCompleted];
            });
        });
        return nil;
    }];
}

@end

@implementation SXVodPlayerControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self configControl];
    return self;
}

- (void)configControl {
    self.fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fullBtn setImage:[UIImage imageNamed:@"sx_icon_vod_resize_0"] forState:UIControlStateSelected];
    [self.fullBtn setImage:[UIImage imageNamed:@"sx_icon_vod_resize_1"] forState:UIControlStateNormal];
    [self addSubview:self.fullBtn];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"sx_icon_vod_play_0"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"sx_icon_vod_play_1"] forState:UIControlStateSelected];
    [self addSubview:self.playBtn];
    
    self.pSlider = [SXProgressSlider new];
    self.pSlider.progress.progressColor = [UIColor colorWithWhite:1 alpha:0.9];
    self.pSlider.progress.downProgressColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self addSubview:self.pSlider];
    
    self.durationLabel = [UILabel new];
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.font = [UIFont systemFontOfSize:14];
    self.durationLabel.textAlignment = NSTextAlignmentLeft;
    
    self.pLabel = [UILabel new];
    self.pLabel.textColor = [UIColor whiteColor];
    self.pLabel.font = [UIFont systemFontOfSize:14];
    self.pLabel.textAlignment = NSTextAlignmentRight;
    
   
    [self addSubview:self.durationLabel];
    [self addSubview:self.pLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat totalW = CGRectGetWidth(self.bounds);
    CGFloat totalH = CGRectGetHeight(self.bounds);
    
    CGFloat edge = 10;
    CGFloat labelW = 50;
    CGFloat btnW = 40;
    CGFloat barH = 40;
    CGFloat barTop = totalH - barH;
    
    self.fullBtn.frame = CGRectMake(totalW - btnW - edge, barTop, btnW, barH);
    self.playBtn.frame = CGRectMake(edge, barTop, btnW, barH);
    
    self.pLabel.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame), barTop, labelW, barH);
    self.durationLabel.frame = CGRectMake(CGRectGetMinX(self.fullBtn.frame) - labelW, barTop, labelW, barH);
    
    CGFloat px = CGRectGetMaxX(self.pLabel.frame) + 10;
    CGFloat ph = 12;
    CGFloat py = (barH - ph) *0.5 + barTop;
    CGFloat pw = CGRectGetMinX(self.durationLabel.frame) - 10 - px;
    self.pSlider.frame = CGRectMake(px, py, pw , ph);
    
}

- (void)stopHideTimer {
    [self.hideTimer invalidate];
    self.hideTimer = nil;
}

- (void)activeHideTimer {
    [self stopHideTimer];
    self.hideTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(_hideControl) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.hideTimer forMode:NSRunLoopCommonModes];
}

- (void)_hideControl {
    self.hidden = true;
}

@end

/// 播放放器旋转通知
 NSString *const SXVodPlayerRotationNotificationName = @"SXVodPlayerRotationNotificationName";

@interface SXVodControlPlayer()<UIGestureRecognizerDelegate>
/// seek前的播放状态
@property (nonatomic, assign) BOOL seekPlaying;
@end

@implementation SXVodControlPlayer

- (void)pause {
    [super pause];
    self.control.playBtn.selected = NO;
}

- (void)resume {
    [super resume];
    self.control.playBtn.selected = YES;
}

- (void)stop {
    [super stop];
    self.control.playBtn.selected = NO;
}

- (CGFloat)duration {
    CGFloat result = [super duration];
    /// 避免计算时分母为0
    return result < 0 ? 1 : result;
}

- (void)setProgress:(CGFloat)progress {
    if (self.progress == progress) return;
    [super setProgress:progress];
    CGFloat p = progress / self.duration;
    [self.control.pSlider seek:p];
    [self updateProgressTime:progress];
}

- (void)setPlayable:(CGFloat)playable {
    if (self.playable == playable) return;
    [super setPlayable:playable];
    CGFloat p = playable / self.duration;
    self.control.pSlider.progress.downProgress = p;
}

- (void)setDuration:(CGFloat)duration {
    if (self.duration == duration) return;
    [super setDuration:duration];
    self.control.durationLabel.text = _SXVodPlayerTime(duration);
}

- (void)updateProgressTime:(CGFloat)second {
    NSString *time = _SXVodPlayerTime(second);
    self.control.pLabel.text = time;
    self.centerTimeLabel.text = time;
    CGPoint center = CGPointMake(CGRectGetMidX(self.centerTimeLabel.superview.bounds), CGRectGetMidY(self.centerTimeLabel.superview.bounds));
    center.y -= CGRectGetHeight(self.centerTimeLabel.frame) * 0.5;
    self.centerTimeLabel.center = center;
}

- (void)configPlayer {
    [super configPlayer];
    SXVodPlayerControl *bar = [[SXVodPlayerControl alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self.contentView insertControl:bar];
    bar.hidden = true;
    self.control = bar;
    [bar.fullBtn addTarget:self action:@selector(rotationPlayer:) forControlEvents:UIControlEventTouchUpInside];
    [bar.playBtn addTarget:self action:@selector(clickedControlPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    __typeof(self) __weak wself = self;
    self.control.pSlider.willSeek = ^{
        [wself willSeek];
    };
    self.control.pSlider.doSeek = ^(CGFloat seek) {
        double p = seek * wself.duration;
        [wself doSeek:p updateSlider:NO];
    };
    self.control.pSlider.endSeek = ^{
        [wself endSeek];
    };
    
    self.centerTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    self.centerTimeLabel.textColor = [UIColor whiteColor];
    self.centerTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.centerTimeLabel.font = [UIFont systemFontOfSize:20];
    self.centerTimeLabel.hidden = true;
    [self.contentView insertSubview:self.centerTimeLabel aboveSubview:bar];
}

- (void)willSeek {
    if (!self.allowControl) return;
    self.seekPlaying = [self isPlaying];
    [self.control stopHideTimer];
    [self pause];
    self.contentView.pauseIcon.hidden = true;
    self.centerTimeLabel.hidden = NO;
}

- (void)doSeek:(double)second updateSlider:(BOOL)slider{
    if (!self.allowControl) return;
    double value = second;
    if (value < 0) value = 0;
    if (value >= self.duration) value = self.duration - 1;
    [self.vodPlayer seek:value];
    [self updateProgressTime:value];
    if (slider) [self.control.pSlider seek:value/self.duration];
}

- (void)endSeek {
    if (!self.allowControl) return;
    [self.control activeHideTimer];
    if (self.seekPlaying) [self resume];
    self.contentView.pauseIcon.hidden = NO;
    self.centerTimeLabel.hidden = YES;
}

- (void)configEvents {
    [super configEvents];
    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    pangesture.delegate = self;
    [self.contentView addGestureRecognizer:pangesture];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return self.allowControl;
    }
    return true;
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint point = [gesture translationInView:gesture.view];
    static double time = 0;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            time = self.progress;
            [self willSeek];
        }
            break;
        case UIGestureRecognizerStateChanged: {
            time += point.x < 0 ? -1 : 1;
            [self doSeek:time updateSlider:YES];
        }
            
            break;
        default:
        {
            [self endSeek];
        }
            break;
    }
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

- (void)clickedControlPlay:(UIButton *)sender {
    [super toggle];
}

- (void)toggle {
    if (![self isPlaying]) {
        [super toggle];
    } else {
        self.control.hidden = !self.control.isHidden;
        [self.control stopHideTimer];
        if (self.control.isHidden == YES) return;
        [self.control activeHideTimer];
    }
}

- (void)dealloc {
    [self.control stopHideTimer];
}

- (void)rotationPlayer:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    /// 横
    UIDeviceOrientation orientation = sender.isSelected ? UIDeviceOrientationLandscapeLeft : UIDeviceOrientationPortrait;
    if (orientation == UIDeviceOrientationPortrait) {
        [self addSubview:self.contentView];
        self.contentView.frame = self.bounds;
    } else {
        UIWindow *window = SXRootWindow();
        CGRect rect = [window convertRect:self.contentView.frame fromView:self];
        [window addSubview:self.contentView];
        self.contentView.frame = rect;
        CGFloat w = CGRectGetHeight([UIScreen mainScreen].bounds);
        CGFloat h = CGRectGetWidth([UIScreen mainScreen].bounds);
        [UIView animateWithDuration:0.25 animations:^{
            self.contentView.frame = CGRectMake(0, 0, w, h);
        }];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SXVodPlayerRotationNotificationName object:@(orientation)];
    [UIDevice sx_rotate:orientation];
}

@end

