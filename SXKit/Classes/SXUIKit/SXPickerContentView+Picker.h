//
//  SXPickerContentView+Picker.h
//  VSocial
//
//  Created by vince on 2021/3/15.
//  Copyright © 2021 vince. All rights reserved.
//

#import "SXPickerContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXPickerContentView (Picker)<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, copy) NSArray <NSString *>*sources;

+ (void)showSources:(NSArray <NSString *>*)sources
           selected:(void(^)(NSInteger idx))selected;
@end

NS_ASSUME_NONNULL_END
