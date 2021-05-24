//
//  SXApp.m
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/5/24.
//

#import "SXApp.h"

@implementation SXApp

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

+ (NSString *)appBuildVersion {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

+ (NSString *)appName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
}

/// 传入的version 和 当前app version 进行比较，返回值： 低于当前版本 -1，等于当前版本0，高于当前版本 1
+ (NSInteger)compareVersion:(NSString *)version {
    NSString *appVersion_ = [self appVersion];
    if ([appVersion_ isEqualToString:version]) return 0;
    NSArray *appVersions = [appVersion_ componentsSeparatedByString:@"."];
    NSArray *versions = [version componentsSeparatedByString:@"."];
    NSInteger count = appVersions.count > versions.count ? appVersions.count : versions.count;
    for (int i = 0; i < count; i++) {
        NSInteger appValue = appVersions.count > i ? [appVersions[i] integerValue] : 0;
        NSInteger value = versions.count > i ? [versions[i] integerValue] : 0;
        if (appValue > value) return -1;
        if (appValue < value) return 1;
    }
    return 0;
    
}
/// 传入的build 和 当前app build 进行比较，返回值： 低于当前版本 -1，等于当前版本0，高于当前版本 1
+ (NSInteger)compareBuildVersion:(NSString *)build {
    NSString *appVersion_ = [self appBuildVersion];
    if ([appVersion_ isEqualToString:build]) return 0;
    NSArray *appVersions = [appVersion_ componentsSeparatedByString:@"."];
    NSArray *versions = [build componentsSeparatedByString:@"."];
    NSInteger count = appVersions.count > versions.count ? appVersions.count : versions.count;
    for (int i = 0; i < count; i++) {
        NSInteger appValue = appVersions.count > i ? [appVersions[i] integerValue] : 0;
        NSInteger value = versions.count > i ? [versions[i] integerValue] : 0;
        if (appValue > value) return -1;
        if (appValue < value) return 1;
    }
    return 0;
}

@end
