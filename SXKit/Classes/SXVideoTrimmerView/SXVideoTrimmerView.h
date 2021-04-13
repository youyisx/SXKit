//
//  SXVideoTrimmerView.h
//  SXMovieCutDemo
//
//  Created by vince_wang on 2021/3/26.
//

#import <UIKit/UIKit.h>
/// 视频幀裁剪框
NS_ASSUME_NONNULL_BEGIN

@interface SXVideoTrimmerView : UIView

@property (nonatomic, assign) CGFloat leftEdge;
@property (nonatomic, assign) CGFloat rightEdge;
/// 幀数
@property (nonatomic, assign) NSUInteger framesCount;
@property (nonatomic, assign) double minIntervalProgress;
@property (nonatomic, assign) double maxIntervalProgress;
/// 单帧图片宽度
@property (nonatomic, assign) CGFloat frameItemWidth;
/// 启动ui渲染逻辑 以上各项属性配置好后 才调用该函数
- (void)activeTrimmerView;
/// 设备各个幀的图片
- (void)setFrame:(UIImage *)image idx:(NSInteger)idx;
/// 0 ~ 1
@property (nonatomic, copy) void(^didChangeTrimmerFrame)(CGFloat start, CGFloat end, CGFloat seek);
@property (nonatomic, copy) void(^willChangeTrimmerFrame)(void);
@property (nonatomic, copy) void(^didEndChangeTrimmerFrame)(void);

- (void)seekSlider:(CGFloat)progress;
@end
 
/**
 * 回调函数使用示范
 * e.g
 NSTimeInterval duration = CMTimeGetSeconds(_moviePlayer.asset.duration);
 self.videoTrimmerView.willChangeTrimmerFrame = ^{
     [wself.moviePlayer stop];
     wself.playButton.hidden = YES;
     wself.dragging = YES;
 };
 self.videoTrimmerView.didChangeTrimmerFrame = ^(CGFloat start, CGFloat end, CGFloat seek) {
     NSTimeInterval seekTime = duration * seek;
     [wself.moviePlayer seekToTime:CMTimeMakeWithSeconds(seekTime, timescale)];
     
     NSTimeInterval startTime = duration * start;
     NSTimeInterval endTime   = duration * end;
     
     CMTimeRange timeRange = CMTimeRangeFromTimeToTime(CMTimeMakeWithSeconds(startTime, timescale), CMTimeMakeWithSeconds(endTime, timescale));
     NSTimeInterval rangeDuration = CMTimeGetSeconds(timeRange.duration);
     wself.timeLabel.text = [NSString stringWithFormat:@"已选择%.1f秒",rangeDuration];
     wself.selectedTimeRange = CMTimeRangeMake(CMTimeMake(timeRange.start.value, timeRange.start.timescale), CMTimeMake(timeRange.duration.value, timeRange.duration.timescale));
 };
 self.videoTrimmerView.didEndChangeTrimmerFrame = ^{
     wself.playButton.hidden = wself.moviePlayer.status == TuSDKMediaPlayerStatusPlaying;
     wself.dragging = NO;
 };
 
 */
NS_ASSUME_NONNULL_END
