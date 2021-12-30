//
//  SXCustomLogger.h
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/9/27.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, SXCustomLogLevel) {
    SXCustomLogLevelDefault = 1<<0,
    SXCustomLogLevelInfo    = 1<<1,
    SXCustomLogLevelWarn    = 1<<2,
};

@interface SXCustomLogger : NSObject
/** 根据 SXCustomLogLevel 来控制某些log是否需要被打印，以便在调试时去掉不关注的log; 默认全部级别都打印 */
@property (nonatomic, class) SXCustomLogLevel showLevel;

+ (void)logWithFile:(nullable const char *)file
               line:(int)line
               func:(nonnull const char *)func
             logStr:(nonnull NSString *)logStr;

+ (void)logWithLevel:(SXCustomLogLevel)level
                file:(nullable const char *)file
                line:(int)line
                func:(nonnull const char *)func
              logStr:(nonnull NSString *)logStr;

+ (NSString *)logNameWithLevel:(SXCustomLogLevel )level;

+ (NSString *)formatString:(NSString *_Nullable)str, ... ;

@end

#ifdef DEBUG

#define SXCLevelLog(_level, _logstr, ...) [SXCustomLogger logWithLevel:_level file:__FILE__ line:__LINE__ func:__FUNCTION__ logStr:[SXCustomLogger formatString:_logstr, ##__VA_ARGS__]];
#define SXCLog(_logstr, ...) SXCLevelLog(SXCustomLogLevelDefault,_logstr, ##__VA_ARGS__)
#define SXCLogInfo(_logstr, ...) SXCLevelLog(SXCustomLogLevelInfo,_logstr, ##__VA_ARGS__)
#define SXCLogWarn(_logstr, ...) SXCLevelLog(SXCustomLogLevelWarn,_logstr, ##__VA_ARGS__)

#else

#define SXCLevelLog(_level, _logstr, ...) {}
#define SXCLog(_logstr, ...) {}
#define SXCLogInfo(_logstr, ...) {}
#define SXCLogWarn(_logstr, ...) {}

#endif


NS_ASSUME_NONNULL_END
