//
//  SXPickerContentView+DatePicker.h
//  VSocial
//
//  Created by vince on 2021/3/15.
//  Copyright © 2021 vince. All rights reserved.
//

#import "SXPickerContentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SXPickerContentView (DatePicker)

+ (void)showDatePicker:(void(^)(NSDate *date))confirm ;

@end

NS_ASSUME_NONNULL_END
