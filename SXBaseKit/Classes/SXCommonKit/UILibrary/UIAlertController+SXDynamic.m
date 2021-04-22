//
//  UIAlertController+SXExt.m
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UIAlertController+SXDynamic.h"
#import "SXNavigationHeader.h"
#import "SXValidLibrary.h"
@implementation UIAlertController (SXDynamic)

+ (RACSignal <NSNumber *>*)sx_alertSignalWithTitle:(nullable NSString *)title
                                           message:(nullable NSString *)msg
                                             items:(nullable NSArray <NSString *>*)items
                                        cancelItem:(nullable NSString *)cancel
                                    highlightIndex:(NSInteger)highlight
                                             style:(UIAlertControllerStyle)style {
    RACSignal *signale = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
            if (cancel.length) {
                [ac addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [subscriber sendError:nil];
                }]];
            }
            for (int i = 0; i < items.count; i++) {
                UIAlertActionStyle actionStyle = highlight == i ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault;
                [ac addAction:[UIAlertAction actionWithTitle:items[i] style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
                    [subscriber sendNext:@(i)];
                    [subscriber sendCompleted];
                }]];
            }
            [SXValidVC() presentViewController:ac animated:true completion:nil];
        });
        return nil;
    }];
    return signale;
}

+ (RACSignal <NSNumber *>*)sx_alertSignalWithTitle:(nullable NSString *)title
                                           message:(nullable NSString *)msg
                                       confirmTips:(nullable NSString *)confirmTips {
    return [self sx_alertSignalWithTitle:title message:msg confirmTips:confirmTips cancelTips:@"取消"];
}

+ (RACSignal<NSNumber *> *)sx_alertSignalWithTitle:(nullable NSString *)title
                                           message:(nullable NSString *)msg
                                       confirmTips:(nullable NSString *)confirmTips
                                        cancelTips:(nullable NSString *)cancelTips {
    NSMutableArray *items = @[].mutableCopy;
    if (confirmTips.length > 0) [items addObject:confirmTips];
    NSString *cancel = cancelTips;
    if (cancel.length == 0) {
        cancel = confirmTips;
        items = nil;
    }
    return  [self sx_alertSignalWithTitle:title
                                  message:msg
                                    items:items
                               cancelItem:cancel
                           highlightIndex:-1
                                    style:UIAlertControllerStyleAlert];
}


+ (RACSignal <NSString *>*)sx_alertSignalWithTitle:(nullable NSString *)title
                                           message:(nullable NSString *)msg
                                       placeHolder:(nullable NSString *)placeHolder {
    return [self sx_alertSignalWithTitle:title message:msg params:@{@"tips":sx_stringWithObject(placeHolder)}];
}

+ (RACSignal <NSString *>*)sx_alertSignalWithTitle:(nullable NSString *)title
                                           message:(nullable NSString *)msg
                                            params:(NSDictionary *)params {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
            [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = sx_stringInDictionaryForKey(params, @"tips");
                NSNumber *keyboardType = sx_numberInDictionaryForKey(params, @"keyboardType");
                if (keyboardType) textField.keyboardType = [keyboardType integerValue];
            }];
            NSString *confirm = sx_stringInDictionaryForKey(params, @"ok");
            if (confirm.length == 0) confirm = @"确认";
            [ac addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [subscriber sendNext:ac.textFields.firstObject.text];
                [subscriber sendCompleted];
            }]];
            NSString *cancel = sx_stringInDictionaryForKey(params, @"cancel");
            if (cancel.length == 0) cancel = @"取消";
            [ac addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [subscriber sendError:nil];
            }]];
            [SXValidVC() presentViewController:ac animated:true completion:nil];
        });
        return nil;
    }];
}
@end


