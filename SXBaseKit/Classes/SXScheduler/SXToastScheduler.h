//
//  SXToast.h
//  SXBaseKit
//
//  Created by taihe-imac-ios-01 on 2021/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SXHUDShowConfiguration)(NSString *_Nullable title , NSDictionary *_Nullable info, UIView *_Nullable contentView, dispatch_block_t completed);

@interface SXToastScheduler : NSObject

@property (nonatomic, copy) SXHUDShowConfiguration toaskShowConfiguration;
/// 忽略相同内容的taost；避免重复弹出一样的内容 默认 yes
@property (nonatomic, assign) BOOL ignoreSameToast;
/// 按先进先出原则，依次弹出toask；默认 yes
@property (nonatomic, assign) BOOL oneByOne;

@property (nonatomic, copy, readonly) NSString *identifier;
+ (instancetype)share;
+ (instancetype)shareIdentifier:(NSString *_Nullable)identifier;

- (void)toast:(NSString *)toast;
- (void)toast:(NSString *_Nullable)toast info:(NSDictionary * _Nullable)info;
- (void)toast:(NSString *_Nullable)toast info:(NSDictionary * _Nullable)info inView:(UIView *_Nullable)view;
- (void)removeAll;
@end

NS_ASSUME_NONNULL_END
