//
//  NSBundle+SXDynamic.m
//  SXKit
//
//  Created by vince on 2021/4/16.
//

#import "NSBundle+SXDynamic.h"

@implementation NSBundle (SXDynamic)

- (UIImage *)sx_img:(NSString *)img {
    if (@available(iOS 13.0, *)) {
        return [UIImage imageNamed:img inBundle:self withConfiguration:nil];
    } else {
        return [UIImage imageWithContentsOfFile:[self sx_imgPath:img]];
    }
}

- (nullable NSString *)sx_imgPath:(NSString *)img {
    if (img.length == 0) return nil;
    NSString *p = [self _sx_cacheImgPaths][img];
    if (p.length == 0) {
        NSArray *paths = [img componentsSeparatedByString:@"."];
        if (paths.count == 1) {/// 没有后缀的情况
            NSArray <NSString *>*types_ = [NSBundle _imgTypes];
            for (NSString *type in types_) {
                if ([type isEqualToString:@"png"]) {
                    int scale = [UIScreen mainScreen].scale;
                    for (int i = scale; i >= 0; i--) {
                        p = [self pathForResource: i > 0 ? [img stringByAppendingFormat:@"@%dx",i] : img ofType:type];
                        if (p.length) break;;
                    }
                } else {
                    p = [self pathForResource:img ofType:type];
                }
                if (p.length) break;;
            }
        } else {
            p = [self pathForResource:img ofType:nil];
        }
        [self _sx_cacheImgPaths][img] = p;
    }
    return p;
}

- (NSMutableDictionary *)_sx_cacheImgPaths {
    NSMutableDictionary *dic = [NSBundle _sx_cacheImgPaths];
    NSMutableDictionary *md = dic[self.resourcePath];
    if (md == nil) {
        md = [NSMutableDictionary dictionary];
        dic[self.resourcePath] = md;
    }
    return md;
}
+ (NSMutableDictionary *)_sx_cacheImgPaths {
    static NSMutableDictionary *dic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = [NSMutableDictionary dictionary];
    });
    return dic;
}

+ (NSArray <NSString *>*)_imgTypes {
    return @[@"png",@"jpg",@"gif",@"jpeg"];
}

@end
