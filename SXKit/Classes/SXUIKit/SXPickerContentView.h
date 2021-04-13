//
//  SXPickerContentView.h
//  VSocial
//
//  Created by taihe-imac-ios-01 on 2021/3/5.
//  Copyright © 2021 vince. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SXPickerContentView : UIView

+ (instancetype)showPicker:(UIView *)pickerVeiw confirm:(dispatch_block_t)confirm;

- (void)hidePicker;
@end


NS_ASSUME_NONNULL_END
