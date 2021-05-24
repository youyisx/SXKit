//
//  SXApp.h
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/5/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXApp : NSObject

+ (NSString *)appVersion;
+ (NSString *)appBuildVersion;
+ (NSString *)appName;

/// 传入的version 和 当前app version 进行比较，返回值： 低于当前版本 -1，等于当前版本0，高于当前版本 1
+ (NSInteger)compareVersion:(NSString *)version;
/// 传入的build 和 当前app build 进行比较，返回值： 低于当前版本 -1，等于当前版本0，高于当前版本 1
+ (NSInteger)compareBuildVersion:(NSString *)build;

@end

NS_ASSUME_NONNULL_END
