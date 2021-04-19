//
//  UITextField+SXDynamic.m
//  VSocial
//
//  Created by vince_wang on 2021/2/24.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UITextField+SXDynamic.h"
#import "NSObject+SXDynamic.h"
@interface SXTextFieldDelegateResponse : NSObject<UITextFieldDelegate>
@property (nonatomic, assign) NSInteger length;
@end

@implementation SXTextFieldDelegateResponse

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.length <= 0) return YES;
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return result.length <= self.length;
}


@end

@implementation UITextField (SXDynamic)

- (void)sx_setMaxTextLength:(NSInteger)length {
    SXTextFieldDelegateResponse *res = [self sx_objectForKey:@"_SXTextFieldDelegateResponse"];
    if (res == nil) {
        res = [SXTextFieldDelegateResponse new];
        [self sx_setObject:res forKey:@"_SXTextFieldDelegateResponse"];
    }
    res.length = length;
    self.delegate = res;
}


- (UITextField * _Nonnull (^)(NSString * _Nullable, UIColor * _Nullable, UIFont * _Nullable))sx_placeholder {
    return ^(NSString *txt, UIColor *color, UIFont *font){
        NSMutableDictionary *parms = [NSMutableDictionary dictionary];
        parms[NSForegroundColorAttributeName] = color;
        parms[NSFontAttributeName] = font;
        if (txt == nil) txt = @"";
        if (parms.count > 0) {
            [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:txt attributes:parms]];
        } else {
            [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:txt]];
        }
        return self;
    };
}

@end

