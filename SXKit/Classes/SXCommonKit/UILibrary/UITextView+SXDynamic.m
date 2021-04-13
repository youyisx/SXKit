//
//  UITextView+SXDynamic.m
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/2/24.
//  Copyright © 2021 vince. All rights reserved.
//

#import "UITextView+SXDynamic.h"
#import "NSObject+SXDynamic.h"
@interface SXTextViewDelegateResponse : NSObject<UITextViewDelegate>
@property (nonatomic, assign) NSInteger length;
@end

@implementation SXTextViewDelegateResponse

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.length <= 0) return YES;
    NSString *result = [textView.text stringByReplacingCharactersInRange:range withString:text];
    return result.length <= self.length;
}

@end

@implementation UITextView (SXDynamic)
- (void)sx_setMaxTextLength:(NSInteger)length {
    SXTextViewDelegateResponse *res = [self sx_objectForKey:@"_SXTextViewDelegateResponse"];
    if (res == nil) {
        res = [SXTextViewDelegateResponse new];
        [self sx_setObject:res forKey:@"_SXTextViewDelegateResponse"];
    }
    res.length = length;
    self.delegate = res;
}
@end
