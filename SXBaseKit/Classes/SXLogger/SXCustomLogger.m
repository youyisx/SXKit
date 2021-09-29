//
//  SXCustomLogger.m
//  SXKit_Example
//
//  Created by taihe-imac-ios-01 on 2021/9/27.
//  Copyright © 2021 vince_wang. All rights reserved.
//

#import "SXCustomLogger.h"

@implementation SXCustomLogger

static SXCustomLogLevel globleLevel = SXCustomLogLevelDefault | SXCustomLogLevelWarn | SXCustomLogLevelInfo;
+ (SXCustomLogLevel)showLevel {
    return globleLevel;
}

+ (void)setShowLevel:(SXCustomLogLevel)showLevel {
    globleLevel = showLevel;
}

+ (void)logWithLevel:(SXCustomLogLevel)level
                file:(const char *)file
                line:(int)line
                func:(const char *)func
              logStr:(nonnull NSString *)logStr {
    if (!(level & self.showLevel)) return;
//    NSString *fileStr = [NSString stringWithFormat:@"%s", file];
    NSString *funcStr = [NSString stringWithFormat:@"%s", func];
    NSString *result = [NSString stringWithFormat:@"%@:%@ | %@", funcStr, @(line), logStr];
    NSLog(@"%@%@",[self logNameWithLevel:level],result);
}

+ (void)logWithFile:(const char *)file
               line:(int)line
               func:(const char *)func
             logStr:(NSString *)logStr{
    [self logWithLevel:SXCustomLogLevelDefault
                  file:file
                  line:line
                  func:func
                logStr:logStr];
    
}

+ (NSString *)logNameWithLevel:(SXCustomLogLevel )level {
    NSString *name = @"";
    if (level & SXCustomLogLevelInfo) {
        name = [name stringByAppendingString:@"ℹ️Info | "];
    }
    if (level & SXCustomLogLevelWarn) {
        name = [name stringByAppendingString:@"🥵Warn | "];
    }
    return name;
}

+ (NSString *)formatString:(NSString *)str, ...  {
    if (!str) return @"";
    va_list args;
    va_start(args, str);
    NSString * text = [[NSString alloc] initWithFormat:str arguments:args];
    va_end(args);
    return text;
}
@end
