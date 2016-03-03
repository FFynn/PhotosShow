//
//  FBLoadPhoto.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "FBLoadPhoto.h"

@interface FBLoadPhoto()

@property (nonatomic, strong) NSMutableArray    *   allPhotos;      //  相片数组
@property (nonatomic, strong) ALAssetsLibrary   *   assetLibrary;
@property (readwrite, copy, nonatomic) void(^loadBlock)(NSArray * photos, NSError * error);

@property (nonatomic, strong) NSMutableArray    *   allPhotoAlbum;  //  相薄数组
@property (nonatomic, strong) ALAssetsLibrary   *   albumAssetLibrary;
@property (readwrite, copy, nonatomic) void(^loadPhotoAlbum)(NSArray * photoAlbum, NSError * error);

@end

@implementation FBLoadPhoto

#pragma mark - 获取相片

//  单例
+ (FBLoadPhoto *)shareLoad {
    static FBLoadPhoto * load;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        load = [[FBLoadPhoto alloc] init];
    });
    return load;
}

- (NSMutableArray *)allPhotos {
    if (!_allPhotos) {
        _allPhotos = [NSMutableArray array];
    }
    return _allPhotos;
}

- (ALAssetsLibrary *)assetLibrary {
    if (!_assetLibrary) {
        _assetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetLibrary;
}

//  加载相片
+ (void)loadAllPhotos:(void (^)(NSArray *, NSError *))completion {
    [[FBLoadPhoto shareLoad].allPhotos removeAllObjects];   //  删除重复
    [[FBLoadPhoto shareLoad] setLoadBlock:completion];
    [[FBLoadPhoto shareLoad] startLoading]; // 开始加载
    
}

//  开始加载所有相片
- (void)startLoading {
    //  获取相片
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset * result, NSUInteger index, BOOL * stop) {
        if (result) {
            FBPhoto * photo = [[FBPhoto alloc] init];
            photo.asset = result;
            [self.allPhotos insertObject:photo atIndex:index];
        }
    };
    
    //  获取相册中的相片
    ALAssetsLibraryGroupsEnumerationResultsBlock  listGroupBlock = ^(ALAssetsGroup * group, BOOL * stop) {
        ALAssetsFilter * onlyPhotoFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotoFilter];
        
        if ([group numberOfAssets] > 0) {
            if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }
        
        if (group == nil) {
            self.loadBlock(self.allPhotos, nil);
        }
        
    };
    
    [self.assetLibrary enumerateGroupsWithTypes:(ALAssetsGroupAll) usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        self.loadBlock(nil, error);
    }];
}

#pragma mark - 获取相薄
- (NSMutableArray *)allPhotoAlbum {
    if (!_allPhotoAlbum) {
        _allPhotoAlbum = [NSMutableArray array];
    }
    return _allPhotoAlbum;
}

- (ALAssetsLibrary *)albumAssetLibrary {
    if (!_albumAssetLibrary) {
        _albumAssetLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _albumAssetLibrary;
}

+ (void)loadAllPhotoAlbum:(void (^)(NSArray *, NSError *))done {
    [[FBLoadPhoto shareLoad].allPhotoAlbum removeAllObjects];
    [[FBLoadPhoto shareLoad] setLoadPhotoAlbum:done];
    [[FBLoadPhoto shareLoad] startLoadingPhotoAlbum];
}

- (void)startLoadingPhotoAlbum {
    [self.albumAssetLibrary enumerateGroupsWithTypes:(ALAssetsGroupAll) usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            if ([group numberOfAssets] > 0) {
                [self.allPhotoAlbum addObject:group];
                NSLog(@"－－－－－－－－－－－－ %@", group);
            }
            
            if (group == nil) {
                self.loadPhotoAlbum(self.allPhotoAlbum, nil);
            }
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"＝＝＝＝＝＝＝＝ 获取相薄出错 %@ ＝＝＝＝＝＝＝", error);
    }];
}

@end
