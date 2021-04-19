//
//  SXPickerContentView+DatePicker.m
//  VSocial
//
//  Created by vince on 2021/3/15.
//  Copyright © 2021 vince. All rights reserved.
//

#import "SXPickerContentView+DatePicker.h"

@implementation SXPickerContentView (DatePicker)

+ (void)showDatePicker:(void(^)(NSDate *))confirm {
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeDate;
    picker.backgroundColor = UIColor.whiteColor;
    picker.date = [NSDate date];
    picker.maximumDate = [NSDate date];
    if (@available(iOS 13.4, *)) picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    [self showPicker:picker confirm:^{
        !confirm?:confirm(picker.date);
    }];
}

@end
