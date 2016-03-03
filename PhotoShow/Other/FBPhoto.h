//
//  FBPhoto.h
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface FBPhoto : NSObject

@property (nonatomic, readonly) UIImage     *       thumbnailImage;     //  缩略图
@property (nonatomic, readonly) UIImage     *       originalImage;      //  原始图
@property (nonatomic, strong)   ALAsset     *       asset;              //  相片对象

@end
