//
//  SXPhotoHelper.m
//  RACDemo
//
//  Created by vince_wang on 2021/1/18.
//  Copyright © 2021 vince. All rights reserved.
//

#import "SXPhotoHelper.h"
#import "UIAlertController+SXDynamic.h"
#import "SXCommon.h"
@interface SXPhotoHelper ()
@property (nonatomic, assign, readwrite) PHAssetMediaType mediaType;
/// 当前相册的资源
@property (nonatomic, strong, readwrite) PHFetchResult *currentAssets;
/// 相册目录
@property (nonatomic, strong, readwrite) NSArray <PHAssetCollection *>*albums;
@end

@implementation SXPhotoHelper

- (instancetype)initWithMediaType:(PHAssetMediaType)mediaType {
    self = [super init];
    if (self) {
        self.mediaType = mediaType;
    }
    return self;
}

-(NSArray<PHAssetCollection *> *)albums {
    if (_albums == nil) _albums = [SXPhotoHelper phAssetCollections];
    return _albums;
}

- (void)setCurrentAlbum:(PHAssetCollection *)currentAlbum {
    if (_currentAlbum == currentAlbum && self.currentAssets) return;
    _currentAlbum = currentAlbum;
    self.currentAssets = [SXPhotoHelper phAssetsFrom:currentAlbum mediaType:self.mediaType];
}

@end

@implementation SXPhotoHelper(Ext)

/// 获取相册目录
+ (NSArray <PHAssetCollection *>*)phAssetCollections {
    NSMutableArray *albums = @[].mutableCopy;
    PHFetchResult *defaultAlbums =  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                             subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                             options:nil];
    for (PHAssetCollection *obj in defaultAlbums) [albums addObject:obj];
    PHFetchResult *customAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                           subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                           options:nil];
    for (PHAssetCollection *obj in customAlbums) [albums addObject:obj];
    return albums;
}
/// 获取相册资源
+ (PHFetchResult *)phAssetsFrom:(nullable PHAssetCollection *)album mediaType:(PHAssetMediaType)type{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors =  @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
    if (type > 0) options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",type];
    return album ? [PHAsset fetchAssetsInAssetCollection:album options:options] : [PHAsset fetchAssetsWithOptions:options];
}

/// 相册授权
+ (RACSignal <NSNumber *>*)phPhotoLibrayAuthorization {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    /// 已经授权
    if (status == PHAuthorizationStatusAuthorized) return [RACSignal return:@(true)];
    /// 没有授权
    if (status != PHAuthorizationStatusNotDetermined) {
        RACSignal *signal = [[UIAlertController alertSignalWithTitle:@"相册访问" message:@"相册访问受限，请到设置中开启访问权限" confirmTips:@"去设置"] doNext:^(NSNumber * _Nullable x) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
        }];
        return [signal flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) { return [RACSignal error:nil]; }];
    }
    /// 弹出授权窗口
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [subscriber sendNext:@(true)];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:nil];
                }
            });
        }];
        return nil;
    }];
}

+ (NSString *)localVideoRootPath {
    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    libDir = [libDir stringByAppendingPathComponent:@"sx_video"];
    BOOL directory;
    [[NSFileManager defaultManager] fileExistsAtPath:libDir isDirectory:&directory];
    if (directory == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:libDir
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return libDir;
}

+ (void)recordFile:(NSString *)file key:(NSString *)key {
    if (file.length == 0) return;
    NSString *path = [[self localVideoRootPath] stringByAppendingPathComponent:@"videolist"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    if (dic == nil) dic = [NSMutableDictionary dictionary];
    dic[key] = file;
    [dic writeToFile:path atomically:YES];
}

+ (NSString *)localVideoFileByKey:(NSString *)key {
    if (key.length == 0) return nil;
    NSString *path = [[self localVideoRootPath] stringByAppendingPathComponent:@"videolist"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    return dic[key];
}

+ (NSMutableDictionary *)saveTasks {
    static NSMutableDictionary *dic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = [NSMutableDictionary dictionary];
    });
    return dic;
}

+ (void)saveLocalVideoWithAsset:(PHAsset *)asset result:(void(^)(NSString *path, NSString *key))result{
    NSString *key = asset.localIdentifier;
    if (key.length == 0 || asset.mediaType != PHAssetMediaTypeVideo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !result?:result(nil,nil);
        });
        return;
    }
    NSString *fileName = [self localVideoFileByKey:key];
    if (fileName.length) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !result?:result([[self localVideoRootPath] stringByAppendingPathComponent:fileName],key);
        });
        return;
    }
    NSMutableArray *resultBlocks = [self saveTasks][key];
    if (resultBlocks != nil) {
        if (result != nil) [resultBlocks addObject:result];
        return;
    } else {
        resultBlocks = [NSMutableArray array];
        [self saveTasks][key] = resultBlocks;
        if (result != nil) [resultBlocks addObject:result];
    }
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    if (resource == nil) return;
    static int a = 0;
    a++;
    fileName = [NSString stringWithFormat:@"%@_%d",@((int64_t)[[NSDate date] timeIntervalSince1970]),a];
    fileName = [fileName stringByAppendingFormat:@"_%@",sx_stringWithObject(resource.originalFilename)];
    
    NSString *localPath = [[self localVideoRootPath] stringByAppendingPathComponent:fileName];
    PHAssetResourceRequestOptions *options = [PHAssetResourceRequestOptions new];
    options.networkAccessAllowed = true;
    [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource toFile:[NSURL fileURLWithPath:localPath] options:options completionHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *path_ = error == nil ? localPath : nil;
            if (path_.length) [self recordFile:fileName key:key];
            NSMutableArray *blocks = [self saveTasks][key];
            for (id object in blocks) {
                void(^bb)(NSString *,NSString *) = object;
                bb(path_,key);
            }
            [self saveTasks][key] = nil;
        });
    }];
}

+ (RACSignal <NSString *>*)saveLocalVideoWithAsset:(PHAsset *)asset {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self saveLocalVideoWithAsset:asset result:^(NSString * _Nonnull path, NSString * _Nonnull key) {
            if (path.length) {
                [subscriber sendNext:path];
                [subscriber sendCompleted];
            } else {
                [subscriber sendError:[NSError sx_cocoaError:@"视频导出失败..."]];
            }
        }];
        return nil;
    }];
}
@end

