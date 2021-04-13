//
//  SXPickerContentView+Picker.m
//  VSocial
//
//  Created by vince on 2021/3/15.
//  Copyright © 2021 vince. All rights reserved.
//

#import "SXPickerContentView+Picker.h"
#import <objc/runtime.h>
#import "SXCommon.h"
@implementation SXPickerContentView (Picker)
@dynamic sources;

- (void)setSources:(NSArray<NSString *> *)sources {
    objc_setAssociatedObject(self, "k_sources", sources, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray<NSString *> *)sources {
    return objc_getAssociatedObject(self, "k_sources");
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.sources.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return sx_stringInArrayAtIndex(self.sources, row);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.sx_w;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    !self.selectedBlock?:self.selectedBlock(row);
}

+ (void)showSources:(NSArray <NSString *>*)sources
           selected:(void(^)(NSInteger idx))selected {
    if (sources.count == 0) return;
    UIPickerView *pickerVeiw = [[UIPickerView alloc] init];
    pickerVeiw.backgroundColor = [UIColor whiteColor];
    SXPickerContentView *contentView = [self showPicker:pickerVeiw confirm:^{
        !selected?:selected([pickerVeiw selectedRowInComponent:0]);
    }];
    contentView.sources = sources;
    pickerVeiw.dataSource = contentView;
    pickerVeiw.delegate = contentView;
}
@end
