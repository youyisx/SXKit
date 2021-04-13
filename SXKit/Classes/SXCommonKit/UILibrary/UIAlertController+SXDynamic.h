//
//  UIAlertController+SXExt.h
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (SXDynamic)

+ (RACSignal <NSNumber *>*)alertSignalWithTitle:(nullable NSString *)title
                                        message:(nullable NSString *)msg
                                          items:(nullable NSArray <NSString *>*)items
                                     cancelItem:(nullable NSString *)cancel
                                 highlightIndex:(NSInteger)highlight
                                          style:(UIAlertControllerStyle)style ;

+ (RACSignal <NSNumber *>*)alertSignalWithTitle:(nullable NSString *)title
                                        message:(nullable NSString *)msg
                                    confirmTips:(nullable NSString *)confirmTips;

+ (RACSignal <NSNumber *>*)alertSignalWithTitle:(nullable NSString *)title
                                        message:(nullable NSString *)msg
                                    confirmTips:(nullable NSString *)confirmTips
                                     cancelTips:(nullable NSString *)cancelTips;

+ (RACSignal <NSString *>*)alertSignalWithTitle:(nullable NSString *)title
                                        message:(nullable NSString *)msg
                                    placeHolder:(nullable NSString *)placeHolder;

+ (RACSignal <NSString *>*)alertSignalWithTitle:(nullable NSString *)title
                                        message:(nullable NSString *)msg
                                         params:(NSDictionary *)params;
@end


NS_ASSUME_NONNULL_END
