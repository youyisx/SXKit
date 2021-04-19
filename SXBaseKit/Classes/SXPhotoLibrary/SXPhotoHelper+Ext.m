//
//  SXPhotoHelper+Ext.m
//  VSocial
//
//  Created by vince_wang on 2021/2/24.
//  Copyright © 2021 vince. All rights reserved.
//

#import "SXPhotoHelper+Ext.h"
#import "SXNavigationHeader.h"
@interface SXImagePickerDelegateResponse : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, assign) BOOL edit;
@property (nonatomic, copy) void(^didFinishPicking)(UIImage *img);
@property (nonatomic, strong) id mySelf;
@end
@implementation SXImagePickerDelegateResponse

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    UIImage *image = info[self.edit? UIImagePickerControllerEditedImage:UIImagePickerControllerOriginalImage];
    !self.didFinishPicking?:self.didFinishPicking(image);
    [picker dismissViewControllerAnimated:true completion:nil];
    self.mySelf = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
    self.mySelf = nil;
}

@end

@implementation SXPhotoHelper (Ext)

+ (void)openSystemPhotoLibaryWithEdit:(BOOL)edit complete:(void(^)(UIImage *img))completed{
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = edit;
    SXImagePickerDelegateResponse *res = [SXImagePickerDelegateResponse new];
    res.didFinishPicking = completed;
    res.edit = edit;
    res.mySelf = res;
    picker.delegate = res;
    SXPresent(picker, YES, nil);
}

@end
